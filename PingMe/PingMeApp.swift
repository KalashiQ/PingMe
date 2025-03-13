import SwiftUI

@main
struct PingMeApp: App {
    @State private var routingViewModel = RoutingViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.routingViewModel, routingViewModel)
        }
    }
}
