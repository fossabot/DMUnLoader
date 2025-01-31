//
//  DMErrorHandlingPodExampleApp.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI
import DMErrorHandling

@main
struct DMErrorHandlingPodExampleApp: App {
    var body: some Scene {
        WindowGroup {
            DMRootLoadingView { _, _ in
                MainTabView()
            }
        }
    }
    
    private struct MainTabView: View {
//        @StateObject private var provider = CustomDMLoadingViewProvider()
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



