import SwiftUI

struct VerificationView: View {
    let email: String
    @Environment(\.dismiss) private var dismiss
    @State private var verificationCode: [String] = Array(repeating: "", count: 6)
    @State private var timeRemaining = 300
    @State private var timer: Timer?
    @State private var canResendCode = false
    
    @Binding var contentOpacity: Double
    @Binding var backgroundHeight: CGFloat
    @Binding var backgroundWidth: CGFloat
    @Binding var isAnimating: Bool
    

    @FocusState private var focusedField: Int?
    
    func startTimer() {
        canResendCode = false
        timeRemaining = 300
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                canResendCode = true
                timer?.invalidate()
            }
        }
    }
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    dismiss()
                    withAnimation(.easeInOut(duration: 1.1)) {
                        backgroundHeight = 745
                        backgroundWidth = 400
                        contentOpacity = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        isAnimating = false
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.leading, 21)
                
                Text("Подтверждение")
                    .font(.custom("Inter", size: 40))
                    .fontWeight(.medium)
                    .lineSpacing(62.93)
                    .padding(.leading, 21)
                
                Text("Код отправлен на \(email)")
                    .foregroundColor(.gray)
                    .padding(.leading, 21)
                    .padding(.top, 8)
                
                HStack(spacing: 12) {
                    ForEach(0..<6) { index in
                        TextField("", text: $verificationCode[index])
                            .frame(width: 45, height: 45)
                            .background(Color(hex: "#CADDAD"))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: index)
                            .onChange(of: verificationCode[index]) { oldValue, newValue in
                                if newValue.count > 1 {
                                    verificationCode[index] = String(newValue.prefix(1))
                                }
                                if !newValue.isEmpty && !newValue.allSatisfy({ $0.isNumber }) {
                                    verificationCode[index] = ""
                                }
                                
                                if !newValue.isEmpty && index < 5 {
                                    focusedField = index + 1
                                }
                                
                                if newValue.isEmpty && index > 0 {
                                    focusedField = index - 1
                                }
                            }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 32)
                .padding(.horizontal, 21)
                
                Button(action: {
                    // Действие при подтверждении кода
                }) {
                    Text("Подтвердить")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 21)
                .padding(.top, 32)
                
                Button(action: {
                    if canResendCode {
                        startTimer()
                    }
                }) {
                    Text(canResendCode ? "Отправить код повторно" : "Отправить повторно через \(formattedTime)")
                        .foregroundColor(canResendCode ? .black : .gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .disabled(!canResendCode)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#CADDAD"))
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(
            email: "test@example.com",
            contentOpacity: .constant(0),
            backgroundHeight: .constant(UIScreen.main.bounds.height),
            backgroundWidth: .constant(UIScreen.main.bounds.width),
            isAnimating: .constant(true)
        )
    }
}

