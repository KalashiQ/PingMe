
import Observation
import Foundation
import CoreFoundation

@Observable
class LoginViewModel {
    var email: String
    var password: String
    var isValidEmail: Bool = true
    var isValidPassword: Bool = true
    
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
        validateEmail()
        validatePassword()
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isValidEmail = emailPredicate.evaluate(with: email)
    }
    
    func validatePassword() {
//        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}"
//        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        isValidPassword = passwordPredicate.evaluate(with: password)
        if password.count >= 8 {
             isValidPassword = true
        } else {
            isValidPassword = false
        }
    }
    
    
}

