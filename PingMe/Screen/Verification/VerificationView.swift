import SwiftUI

// MARK: - Main View
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
    @Environment(\.routinViewModel) private var routinViewModel
    private let password: String

    // MARK: - Initialization
    init(
        email: String,
        password: String,
        isFromLogin: Bool,
        contentOpacity: Binding<Double>,
        backgroundHeight: Binding<CGFloat>,
        backgroundWidth: Binding<CGFloat>,
        isAnimating: Binding<Bool>,
        onBack: @escaping () -> Void
    ) {
        _viewModel = State(
            initialValue: VerificationViewModel(
                email: email, password: password, isFromLogin: isFromLogin))
        _contentOpacity = contentOpacity
        _backgroundHeight = backgroundHeight
        _backgroundWidth = backgroundWidth
        _isAnimating = isAnimating
        self.password = password
        self.viewModel.onBack = onBack
    }

    // MARK: - Body View
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1)
                            )
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: index)
                            .onChange(of: viewModel.verificationCode[index]) { oldValue, newValue in
                                if let nextField = viewModel.handleCodeInput(
                                    at: index, newValue: newValue) {
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
                        if let userData = await viewModel.verifyCode() {
                            viewModel.saveUserData(userData)
                            routinViewModel.navigateToScreen(.chats)
                        } else if let error = viewModel.errorMessage {
                            errorMessage = error
                            showError = true
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
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }

                Button(action: viewModel.resendCode) {
                    Text(
                        viewModel.canResendCode
                            ? "Отправить код повторно"
                            : "Отправить повторно через \(viewModel.formattedTime)"
                    )
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

// MARK: - Preview
#Preview {
    VerificationView(
        email: "",
        password: "",
        isFromLogin: true,
        contentOpacity: .constant(0),
        backgroundHeight: .constant(UIScreen.main.bounds.height),
        backgroundWidth: .constant(UIScreen.main.bounds.width),
        isAnimating: .constant(true),
        onBack: {}
    )
}
