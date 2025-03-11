import SwiftUI

struct ContentView: View {
    @Environment(\.routinViewModel) private var routinViewModel
    var body: some View {
            switch routinViewModel.currentScreen {
            case .splash:
                SplashView()
            case .login:
                LoginView()
            case .chats:
                ChatsView()
            }
    }
}

#Preview {
    ContentView()
}
