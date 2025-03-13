import SwiftUI

enum AppScreen {
    case splash
    case login
    case chats
}

@Observable
class RoutingViewModel {
    var currentScreen: AppScreen = .splash

    func navigateToScreen(_ screen: AppScreen) {
        currentScreen = screen
    }
}

private struct RoutingViewModelKey: EnvironmentKey {
    static let defaultValue = RoutingViewModel()
}

extension EnvironmentValues {
    var routingViewModel: RoutingViewModel {
        get { self[RoutingViewModelKey.self] }
        set { self[RoutingViewModelKey.self] = newValue }
    }
}
