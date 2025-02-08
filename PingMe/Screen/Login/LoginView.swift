import SwiftUI

struct LoginView: View {
    
    @State private var viewModel = LoginViewModel(email: "Kalashiq.org@gmail.com", password: "Password#123")
    
    var body: some View {
        ZStack {
            BackgroundView(height: viewModel.backgroundHeight, width: viewModel.backgroundWidth)
                .animation(.easeInOut(duration: 1.1), value: viewModel.backgroundHeight)
                .animation(.easeInOut(duration: 1.1), value: viewModel.backgroundWidth)
            
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
                        viewModel.showGoogleAlert = true
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
                    .alert("В разработке", isPresented: $viewModel.showGoogleAlert) {
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
            .opacity(viewModel.contentOpacity)
        }
        .padding(.top, 153)
        .overlay {
            if viewModel.isAnimatingLogin {
                VerificationView(
                    email: viewModel.email,
                    contentOpacity: $viewModel.contentOpacity,
                    backgroundHeight: $viewModel.backgroundHeight,
                    backgroundWidth: $viewModel.backgroundWidth,
                    isAnimating: $viewModel.isAnimatingLogin
                )
                .opacity(1 - viewModel.contentOpacity)
            }
            
            if viewModel.isAnimatingRegistration {
                RegistrationView(
                    contentOpacity: $viewModel.contentOpacity,
                    backgroundHeight: $viewModel.backgroundHeight,
                    backgroundWidth: $viewModel.backgroundWidth,
                    isAnimating: $viewModel.isAnimatingRegistration
                )
                .opacity(1 - viewModel.contentOpacity)
            }
        }
    }
    
    private func startTransitionAnimation(for login: Bool) {
        if login {
            viewModel.isAnimatingLogin = true
        } else {
            viewModel.isAnimatingRegistration = true
        }

        withAnimation(.easeInOut(duration: 1.1)) {
            viewModel.backgroundHeight = UIScreen.main.bounds.height + 200
            viewModel.backgroundWidth = UIScreen.main.bounds.width
            viewModel.contentOpacity = 0
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

