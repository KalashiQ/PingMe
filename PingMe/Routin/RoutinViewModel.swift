import SwiftUI

enum AppScreen {
    case splash
    case login
    case chats
}

@Observable
class RoutinViewModel {
    var currentScreen: AppScreen = .splash

    func navigateToScreen(_ screen: AppScreen) {
        currentScreen = screen
    }
}

private struct RoutinViewModelKey: EnvironmentKey {
    static let defaultValue = RoutinViewModel()
}

extension EnvironmentValues {
    var routinViewModel: RoutinViewModel {
        get { self[RoutinViewModelKey.self] }
        set { self[RoutinViewModelKey.self] = newValue }
    }
}
