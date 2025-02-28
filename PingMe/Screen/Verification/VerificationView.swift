import SwiftUI

struct VerificationView: View {
    @State private var viewModel: VerificationViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var contentOpacity: Double
    @Binding var backgroundHeight: CGFloat
    @Binding var backgroundWidth: CGFloat
    @Binding var isAnimating: Bool
    @FocusState private var focusedField: Int?
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    private let password: String
    
    init(email: String, 
         password: String,
         contentOpacity: Binding<Double>, 
         backgroundHeight: Binding<CGFloat>, 
         backgroundWidth: Binding<CGFloat>, 
         isAnimating: Binding<Bool>,
         onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: VerificationViewModel(email: email, password: password))
        _contentOpacity = contentOpacity
        _backgroundHeight = backgroundHeight
        _backgroundWidth = backgroundWidth
        _isAnimating = isAnimating
        self.password = password
        self.viewModel.onBack = onBack
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    viewModel.onBack()
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
                
                Text("Код отправлен на \(viewModel.email)")
                    .foregroundColor(.gray)
                    .padding(.leading, 21)
                    .padding(.top, 8)
                
                HStack(spacing: 12) {
                    ForEach(0..<6) { index in
                        TextField("", text: $viewModel.verificationCode[index])
                            .frame(width: 45, height: 45)
                            .background(Color(hex: "#CADDAD"))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: index)
                            .onChange(of: viewModel.verificationCode[index]) { oldValue, newValue in
                                if let nextField = viewModel.handleCodeInput(at: index, newValue: newValue) {
                                    focusedField = nextField
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 32)
                .padding(.horizontal, 21)
                
                Button(action: {
                    Task {
                        do {
                            if let userData = try await viewModel.verifyCode() {
                                viewModel.saveUserData(userData)
                                
                                // Закрываем текущее представление
                                presentationMode.wrappedValue.dismiss()
                                
                                // Переходим на ChatsView через главное окно
                                DispatchQueue.main.async {
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let window = windowScene.windows.first {
                                        withAnimation {
                                            window.rootViewController = UIHostingController(rootView: ChatsView())
                                            window.makeKeyAndVisible()
                                        }
                                    }
                                }
                            }
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                            print("Verification error: \(error)")
                        }
                    }
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
                .alert("Ошибка", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }
                
                Button(action: viewModel.resendCode) {
                    Text(viewModel.canResendCode ? "Отправить код повторно" : "Отправить повторно через \(viewModel.formattedTime)")
                        .foregroundColor(viewModel.canResendCode ? .black : .gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .disabled(!viewModel.canResendCode)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#CADDAD"))
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

#Preview {
        VerificationView(
            email: "",
            password: "",
            contentOpacity: .constant(0),
            backgroundHeight: .constant(UIScreen.main.bounds.height),
            backgroundWidth: .constant(UIScreen.main.bounds.width),
            isAnimating: .constant(true),
            onBack: {}
        )
}

