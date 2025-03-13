import SwiftUI

@main
struct PingMeApp: App {
    @State private var routinViewModel = RoutinViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.routinViewModel, routinViewModel)
        }
    }
}
