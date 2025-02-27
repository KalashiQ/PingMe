import Observation
import Foundation
import CoreFoundation

@Observable
class VerificationViewModel {
    var verificationCode: [String] = Array(repeating: "", count: 6)
    var timeRemaining = 300
    var timer: Timer?
    var canResendCode = false
    var email: String
    var onBack: () -> Void = {}
    
    init(email: String) {
        self.email = email
    }
    
    func startTimer() {
        canResendCode = false
        timeRemaining = 300
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
    func verifyCode() async throws {
        let code = verificationCode.joined()
        do {
            let registrationVM = RegistrationViewModel(email: email, password: "", confirmPassword: "")
            if let userData = try await registrationVM.verifyRegistration(token: code) {
                // Сохранить токены и данные пользователя
                print("Verification successful: \(userData)")
                // Перейти к следующему экрану
            }
        } catch {
            print("Verification error: \(error)")
            throw error
        }
    }
    
    func resendCode() {
        if canResendCode {
            startTimer()
        }
    }
}
