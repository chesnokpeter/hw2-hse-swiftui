import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup("Покупки") {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 420, minHeight: 450)
                #endif
        }
    }
}
