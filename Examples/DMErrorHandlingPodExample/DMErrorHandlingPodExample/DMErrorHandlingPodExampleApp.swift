//
//  DMErrorHandlingPodExampleApp.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import DMErrorHandling

//TODO: move inner func/class implementation to some places where those can be checked each time build app and not ommited because of `#if ... #elseif ...` macros!

#if UIKIT_APP

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootVC = DMRootViewController()
        
        let tabViewControlelr = MainTabViewControllerUIKit()
        
        // Add MainTabViewControllerUIKit as a child controller
        tabViewControlelr.willMove(toParent: rootVC)
        rootVC.addChild(tabViewControlelr)
        tabViewControlelr.view.frame = rootVC.view.bounds
        tabViewControlelr.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootVC.view.addSubview(tabViewControlelr.view)
        tabViewControlelr.didMove(toParent: rootVC)
        
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
}

#elseif SWIFTUI_APP

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
