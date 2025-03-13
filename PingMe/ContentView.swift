import SwiftUI

struct ContentView: View {
    @Environment(\.routingViewModel) private var routingViewModel
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
