//
//  DMErrorHandlingPodExampleApp.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import DMErrorHandling


//TODO: move inner func/class implementation to some places where those can be checked each time build app and not ommited because of `#if ... #elseif ...` macros!

#if UIKIT_APP

// UIKit-App
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootVC = DMRootViewController()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
}

#elseif SWIFTUI_APP

// SwiftUI-App
import SwiftUI

@main
struct DMErrorHandlingPodExampleApp: App {
    var body: some Scene {
        WindowGroup {
            DMRootLoadingView {
                MainTabView()
            }
        }
    }
    
    private struct MainTabView: View {
        var body: some View {
            TabView {
                ContentViewDefaultSettings()
                    .tabItem {
                        Label("Default", systemImage: "gearshape")
                    }
                
                ContentViewCustomSettings()
                    .tabItem {
                        Label("Custom", systemImage: "pencil")
                    }
            }
        }
    }
}
#endif
