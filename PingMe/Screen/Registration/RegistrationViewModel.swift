import Observation
import Foundation
import CoreFoundation

@Observable
class RegistrationViewModel {
    var email: String
    var isValidEmail: Bool = true
    var password: String
    var confirmPassword: String
    var isValidPassword: Bool = true
    var isValidPasswordMatch: Bool = true
    var username: String = ""
    var showVerification: Bool = false
    
    init(email: String = "", password: String = "", confirmPassword: String = "") {
        self.email = email
        self.isValidEmail = true
        self.password = password
        self.confirmPassword = confirmPassword
        self.isValidPassword = true
    }
    
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
    
    
    func validatePasswordMatch() {
        isValidPasswordMatch = !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
    }
    
    func isValidForm() -> Bool {
        return isValidEmail && isValidPassword && isValidPasswordMatch && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
}

