import CoreFoundation
import Foundation
import Observation

// MARK: - View Model
@Observable
class VerificationViewModel {
    private let authService = AuthService()
    var verificationCode: [String] = Array(repeating: "", count: 6)
    var timeRemaining = 3
    var timer: Timer?
    var canResendCode = false
    var email: String
    var onBack: () -> Void = {}
    private let password: String
    var username: String = ""
    var isFromLogin: Bool
    var errorMessage: String?

    // MARK: - Initialization
    init(email: String, password: String, isFromLogin: Bool, username: String = "") {
        self.email = email
        self.password = password
        self.isFromLogin = isFromLogin
        self.username = username
    }

    // MARK: - Timer Management
    func startTimer() {
        canResendCode = false
        timeRemaining = 3
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
    func verifyCode() async -> VerifyResponseData? {
        let code = verificationCode.joined()

        if code.count != 6 {
            errorMessage = "The code must consist of 6 digits."
            return nil
        }

        do {
            let response =
                try await isFromLogin
                ? authService.verifyLogin(email: email, password: password, token: code)
                : authService.verifyRegistration(email: email, password: password, token: code)

            if !response.success {
                errorMessage = "Invalid confirmation code"
                clearVerificationCode()
                return nil
            }

            guard let userData = response.data else {
                errorMessage = "Успешный ответ без данных пользователя"
                return nil
            }

            return userData

        } catch {
            errorMessage = "Invalid confirmation code"
            clearVerificationCode()
            return nil
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
            Task {
                do {
                    let response =
                        try await isFromLogin
                        ? authService.login(email: email, password: password)
                        : authService.register(email: email, password: password, name: username)

                    if response.success {
                        await MainActor.run {
                            startTimer()
                        }
                    } else {
                        errorMessage = response.error ?? "Failed to resend code"
                    }
                } catch {
                    errorMessage = "Failed to resend code"
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func clearVerificationCode() {
        verificationCode = Array(repeating: "", count: 6)
    }
}
