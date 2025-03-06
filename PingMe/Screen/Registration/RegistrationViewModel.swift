import CoreFoundation
import Foundation
import Observation

// MARK: - View Model
@Observable
class RegistrationViewModel {
    private let authService = AuthService()
    var email: String
    var isValidEmail: Bool = true
    var password: String
    var confirmPassword: String
    var isValidPassword: Bool = true
    var isValidPasswordMatch: Bool = true
    var username: String = "@Kalashiq"
    var isValidUsername: Bool = true
    var showVerification: Bool = false
    var onBack: (() -> Void)?
    var isFromLogin: Bool = false
    var errorMessage: String?

    // MARK: - Initialization
    init(
        email: String = "",
        password: String = "",
        confirmPassword: String = "",
        isFromLogin: Bool = false
    ) {
        self.email = email
        self.isValidEmail = true
        self.password = password
        self.confirmPassword = confirmPassword
        self.isValidPassword = true
        self.isFromLogin = isFromLogin

    }

    // MARK: - Validation Methods
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isValidEmail = emailPredicate.evaluate(with: email)
    }

    func validatePassword() {
        if password.count >= 8 {
            isValidPassword = true
        } else {
            isValidPassword = false
        }
    }

    func validateUsername() {
        let usernameRegex = "^@[A-Za-z][A-Za-z0-9]{5,}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        isValidUsername = usernamePredicate.evaluate(with: username)
    }

    func validatePasswordMatch() {
        isValidPasswordMatch =
            !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
    }

    func isValidForm() -> Bool {
        isValidEmail && isValidPassword && isValidPasswordMatch && isValidUsername && !email.isEmpty
            && !password.isEmpty && !confirmPassword.isEmpty && !username.isEmpty
    }

    // MARK: - Authentication Methods
    @MainActor
    func register() async {
        do {
            let response = try await authService.register(
                email: email,
                password: password,
                name: username.replacingOccurrences(of: "@", with: "")
            )

            if !response.success {
                errorMessage = response.error ?? "Registration failed"
                return
            }

            print("Registration successful, setting isFromLogin to false")
            isFromLogin = false
            showVerification = true

        } catch {
            print("Registration error: \(error)")
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func verifyRegistration(token: String) async -> VerifyResponseData? {
        do {
            isFromLogin = false
            let response = try await authService.verifyRegistration(
                email: email,
                password: password,
                token: token
            )

            if !response.success {
                errorMessage = response.error ?? "Verification failed"
                return nil
            }

            return response.data

        } catch {
            print("Verification error: \(error)")
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
