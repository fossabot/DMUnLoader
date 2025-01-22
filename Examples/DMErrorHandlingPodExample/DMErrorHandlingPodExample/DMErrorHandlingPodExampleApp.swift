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
//    @StateObject private var loadingManager = LoadingManager()
    
    var body: some Scene {
        WindowGroup {
            RootLoadingView {
                ContentView()
            }
//            #2
//            ContentView()
//                .environmentObject(loadingManager)
        }
    }
}
