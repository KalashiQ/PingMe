import Foundation
import Observation

// MARK: - View Model
@Observable
class LoginViewModel {
    var showVerification: Bool = false
    var showRegistration: Bool = false
    var showGoogleAlert: Bool = false
    var email: String
    var password: String
    var isValidEmail: Bool = true
    var isValidPassword: Bool = true
    var backgroundHeight: CGFloat = 745
    var backgroundWidth: CGFloat = 400
    var contentOpacity: Double = 1
    var isAnimatingLogin: Bool = false
    var isAnimatingRegistration: Bool = false
    var isFromLogin: Bool = true
    private let authService = AuthService()
    var errorMessage: String?
    var emailErrorMessage: String = ""
    var passwordErrorMessage: String = ""
    var showAlert: Bool = false
    var alertMessage: String = ""

    // MARK: - Initialization
    init(email: String = "", password: String = "", isFromLogin: Bool) {
        self.email = email
        self.password = password
        self.isFromLogin = isFromLogin
        validateEmail()
        validatePassword()
    }

    // MARK: - Validation Methods
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isValidEmail = emailPredicate.evaluate(with: email)
        emailErrorMessage = isValidEmail ? "" : "Invalid email format".localized
    }

    func validatePassword() {
        isValidPassword = password.count >= 8
        passwordErrorMessage = isValidPassword ? "" : "The password must contain at least 8 characters.".localized
    }

    // MARK: - Authentication Methods
    @MainActor
    func login() async {
        do {
            let response = try await authService.login(email: email, password: password)

            if !response.success {
                errorMessage = response.error ?? "Login failed".localized
                return
            }

            showVerification = true

        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
            alertMessage = "Invalid email or password".localized
        }
    }
}
