import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var isValidEmail: Bool = true
    @State private var password: String = ""
    @State private var isValidPassword: Bool = true
    @State private var showVerification: Bool = false
    @State private var showRegistration: Bool = false
    @State private var showGoogleAlert: Bool = false
    
    
    @State private var viewModel = LoginViewModel(email: "Kalashiq.org@gmail.com", password: "Password#123")
    
    @State private var backgroundHeight: CGFloat = 745
    @State private var backgroundWidth: CGFloat = 400
    @State private var contentOpacity: Double = 1
    @State private var isAnimatingLogin: Bool = false
    @State private var isAnimatingRegistration: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView(height: backgroundHeight, width: backgroundWidth)
                .animation(.easeInOut(duration: 1.1), value: backgroundHeight)
                .animation(.easeInOut(duration: 1.1), value: backgroundWidth)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Войти")
                        .font(.custom("Inter", size: 52))
                        .fontWeight(.medium)
                        .lineSpacing(62.93)
                        .padding(.leading, 21)

                        VStack(alignment: .center, spacing: 14) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("e-mail:")
                                    .font(.custom("Inter", size: 21))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(hex: "#525252"))
                                    .padding(.horizontal, 8)
                                    .frame(width: 97, height: 23)
                                    .background(Color(hex: "#CADDAD"))
                                    .zIndex(1)
                                    .offset(x: 16, y: 10)
                                
                                TextField("", text: $viewModel.email)
                                    .onChange(of: viewModel.email) { _, _ in
                                        viewModel.validateEmail()
                                    }
                                    .padding()
                                    .frame(width: 322, height: 60)
                                    .background(Color(hex: "#CADDAD"))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(viewModel.isValidEmail ? Color.black : Color.red, lineWidth: 1))
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("пароль:")
                                    .font(.custom("Inter", size: 21))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(hex: "#525252"))
                                    .padding(.horizontal, 8)
                                    .frame(width: 103, height: 23)
                                    .background(Color(hex: "#CADDAD"))
                                    .zIndex(1)
                                    .offset(x: 16, y: 10)
                                
                                SecureField("", text: $viewModel.password)
                                    .onChange(of: viewModel.password) { _, _ in
                                        viewModel.validatePassword()
                                    }
                                    .padding()
                                    .frame(width: 322, height: 60)
                                    .background(Color(hex: "#CADDAD"))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(viewModel.isValidPassword ? Color.black : Color.red, lineWidth: 1))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 28)
                    
                    
                    HStack {
                        Button(action: {
                            handleLoginButton()
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.leading, 288)
                        }
                        .padding(.top, 26)
                        .padding(.bottom, 50)
                    }
                    
                    Button(action: {
                        showGoogleAlert = true
                    }) {
                        HStack {
                            Text("Вход через Google")
                                .foregroundColor(Color(hex: "#525252"))
                            Image("Google")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 1)
                        }
                        .frame(width: 261, height: 52)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .alert("В разработке", isPresented: $showGoogleAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Функция входа через Google находится в разработке")
                    }
                    
                    Button(action: {
                        handleRegistrationButton()
                    }) {
                        Text("Зарегистрироваться")
                            .foregroundColor(Color(hex: "#525252"))
                            .frame(width: 261, height: 52)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                }
                .padding(.top, 65)
                .padding()
                
            }
            .frame(width: 400, height: 745, alignment: .top)
            .opacity(contentOpacity)
        }
        .padding(.top, 153)
        .overlay {
            if isAnimatingLogin {
                VerificationView(
                    email: viewModel.email,
                    contentOpacity: $contentOpacity,
                    backgroundHeight: $backgroundHeight,
                    backgroundWidth: $backgroundWidth,
                    isAnimating: $isAnimatingLogin
                )
                .opacity(1 - contentOpacity)
            }
            
            if isAnimatingRegistration {
                RegistrationView(
                    contentOpacity: $contentOpacity,
                    backgroundHeight: $backgroundHeight,
                    backgroundWidth: $backgroundWidth,
                    isAnimating: $isAnimatingRegistration
                )
                .opacity(1 - contentOpacity)
            }
        }
    }
    
    private func startTransitionAnimation(for login: Bool) {
        if login {
            isAnimatingLogin = true
        } else {
            isAnimatingRegistration = true
        }

        withAnimation(.easeInOut(duration: 1.1)) {
            backgroundHeight = UIScreen.main.bounds.height + 200
            backgroundWidth = UIScreen.main.bounds.width
            contentOpacity = 0
        }
    }
        
        private func handleLoginButton() {
            viewModel.validateEmail()
            viewModel.validatePassword()
            
            if viewModel.isValidEmail && viewModel.isValidPassword {
                startTransitionAnimation(for: true)
            }
        }
    
    private func handleRegistrationButton() {
        startTransitionAnimation(for: false)
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

