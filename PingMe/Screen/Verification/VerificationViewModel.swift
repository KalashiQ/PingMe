import CoreFoundation
import Foundation
import Observation

// MARK: - View Model
@Observable
class VerificationViewModel {
    private let authService = AuthService()
    var verificationCode: [String] = Array(repeating: "", count: 6)
    var timeRemaining = 300
    var timer: Timer?
    var canResendCode = false
    var email: String
    var onBack: () -> Void = {}
    private let password: String
    var username: String = ""
    var isFromLogin: Bool

    // MARK: - Initialization
    init(email: String, password: String, isFromLogin: Bool) {
        self.email = email
        self.password = password
        self.isFromLogin = isFromLogin
    }

    // MARK: - Timer Management
    func startTimer() {
        canResendCode = false
        timeRemaining = 5
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.canResendCode = true
                self.timer?.invalidate()
            }
        }
    }

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Input Handling
    func handleCodeInput(at index: Int, newValue: String) -> Int? {
        if newValue.count > 1 {
            verificationCode[index] = String(newValue.prefix(1))
        }
        if !newValue.isEmpty && !newValue.allSatisfy({ $0.isNumber }) {
            verificationCode[index] = ""
        }

        if !newValue.isEmpty && index < 5 {
            return index + 1
        }

        if newValue.isEmpty && index > 0 {
            return index - 1
        }

        return nil
    }

    // MARK: - Lifecycle Methods
    func onDisappear() {
        timer?.invalidate()
    }

    // MARK: - Authentication Methods
    @MainActor
    func verifyCode() async throws -> VerifyResponseData? {
        let code = verificationCode.joined()

        guard code.count == 6 else {
            throw AuthError.serverError("Код должен состоять из 6 цифр")
        }

        let response = try await isFromLogin
            ? authService.verifyLogin(email: email, password: password, token: code)
            : authService.verifyRegistration(email: email, password: password, token: code)

        if response.success {
            if let userData = response.data {
                return userData
            } else {
                throw AuthError.serverError("Успешный ответ без данных пользователя")
            }
        } else {
            throw AuthError.serverError(response.error ?? "Ошибка верификации")
        }
    }

    // MARK: - Data Management
    func saveUserData(_ userData: VerifyResponseData) {
        UserDefaults.standard.set(userData.tokens.access.token, forKey: "accessToken")
        UserDefaults.standard.set(userData.tokens.refresh.token, forKey: "refreshToken")
        UserDefaults.standard.set(
            userData.tokens.access.expiresAt.timeIntervalSince1970, forKey: "accessTokenExpiration")
        UserDefaults.standard.set(
            userData.tokens.refresh.expiresAt.timeIntervalSince1970,
            forKey: "refreshTokenExpiration")

        if let encodedUser = try? JSONEncoder().encode(userData.user) {
            UserDefaults.standard.set(encodedUser, forKey: "userData")
        }

        UserDefaults.standard.synchronize()
    }

    // MARK: - Code Resend
    func resendCode() {
        if canResendCode {
            startTimer()
        }
    }
}
