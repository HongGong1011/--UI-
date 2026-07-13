import SwiftUI

@main
struct 植物记录App: App {
    @StateObject private var store = PlantStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}