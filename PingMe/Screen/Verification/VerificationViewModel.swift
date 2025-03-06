import CoreFoundation
import Foundation
import Observation

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

    init(email: String, password: String, isFromLogin: Bool) {
        self.email = email
        self.password = password
        self.isFromLogin = isFromLogin
        print("VerificationViewModel initialized with isFromLogin: \(isFromLogin)")
    }

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

    func onDisappear() {
        timer?.invalidate()
    }

    @MainActor
    func verifyCode() async throws -> VerifyResponseData? {
        let code = verificationCode.joined()

        print("\n=== Verification Process Debug ===")
        print("Step 1: Input Validation")
        print("Email: \(email)")
        print("Password: [HIDDEN]")
        print("Verification code: \(code)")
        print("Code array state: \(verificationCode)")

        guard code.count == 6 else {
            print("❌ Validation Failed: Code length is not 6 digits")
            throw AuthError.serverError("Код должен состоять из 6 цифр")
        }

        print("✅ Input Validation Passed")

        do {
            print("\nStep 2: Sending Request")
            print("Calling verify\(isFromLogin ? "Login" : "Registration") with:")
            print("- Email: \(email)")
            print("- Code: \(code)")

            let response =
                try await isFromLogin
                ? authService.verifyLogin(email: email, password: password, token: code)
                : authService.verifyRegistration(email: email, password: password, token: code)

            print("\nStep 3: Processing Response")
            print("Response received:")
            print("- Success: \(response.success)")
            print("- Message: \(response.message ?? "No message")")
            print("- Error: \(response.error ?? "No error")")
            print("- Has Data: \(response.data != nil)")

            if response.success {
                if let userData = response.data {
                    print("✅ Verification Successful!")
                    print("User Data received:")
                    print("- User ID: \(userData.user.id)")
                    print("- Email: \(userData.user.email)")
                    print("- Name: \(userData.user.name)")
                    return userData
                } else {
                    print("❌ Error: Response success but no user data")
                    throw AuthError.serverError("Успешный ответ без данных пользователя")
                }
            } else {
                print("❌ Error: Server returned failure")
                throw AuthError.serverError(response.error ?? "Ошибка верификации")
            }
        } catch {
            print("\n❌ Error Occurred:")
            print("Error type: \(type(of: error))")
            print("Error description: \(error.localizedDescription)")
            if let authError = error as? AuthError {
                print("AuthError details: \(authError)")
            }
            throw error
        }
    }

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

    func resendCode() {
        if canResendCode {
            startTimer()
        }
    }
}
