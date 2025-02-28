import Observation
import Foundation
import CoreFoundation

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
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
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
    func verifyCode() async throws -> VerifyResponseData? {
        let code = verificationCode.joined()
        
        // Добавляем отладочную информацию
        print("=== Verification Debug Info ===")
        print("Email: \(email)")
        print("Verification code: \(code)")
        print("Code length: \(code.count)")
        print("Individual digits: \(verificationCode)")
        print("==========================")
        
        guard code.count == 6 else {
            print("Error: Code length is not 6 digits")
            throw AuthError.serverError("Код должен состоять из 6 цифр")
        }
        
        do {
            print("Sending verification request to server...")
            let response = try await authService.verifyRegistration(
                email: email,
                password: password,
                token: code
            )
            
            print("Server response received:")
            print("Success: \(response.success)")
            print("Message: \(response.message ?? "No message")")
            print("Error: \(response.error ?? "No error")")
            
            if response.success {
                if let userData = response.data {
                    print("Verification successful! User data received.")
                    return userData
                }
            }
            throw AuthError.serverError(response.error ?? "Ошибка верификации")
        } catch {
            print("Verification failed with error: \(error)")
            throw error
        }
    }
    
    func saveUserData(_ userData: VerifyResponseData) {
        // Сохраняем токены
        UserDefaults.standard.set(userData.tokens.access.token, forKey: "accessToken")
        UserDefaults.standard.set(userData.tokens.refresh.token, forKey: "refreshToken")
        UserDefaults.standard.set(userData.tokens.access.expiresAt.timeIntervalSince1970, forKey: "accessTokenExpiration")
        UserDefaults.standard.set(userData.tokens.refresh.expiresAt.timeIntervalSince1970, forKey: "refreshTokenExpiration")
        
        // Сохраняем данные пользователя
        if let encodedUser = try? JSONEncoder().encode(userData.user) {
            UserDefaults.standard.set(encodedUser, forKey: "userData")
        }
        
        // Синхронизируем изменения
        UserDefaults.standard.synchronize()
    }
    
    func resendCode() {
        if canResendCode {
            startTimer()
        }
    }
}
