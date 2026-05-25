import SwiftUI

@main
struct BinPeekApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                AddressView()
                    .tabItem {
                        Label("Address", systemImage: "mappin.and.ellipse")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
        }
    }
}
