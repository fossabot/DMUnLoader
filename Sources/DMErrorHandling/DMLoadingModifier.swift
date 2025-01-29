//
//  DMLoadingModifier.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 24.01.2025.
//

import SwiftUICore

/// Modifier to add LoadingView to any View
public struct DMLoadingModifier: ViewModifier {
    @ObservedObject internal var loadingManager: DMLoadingManager
    @ObservedObject internal var settingsProvider: BaseDMLoadingViewProvider
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: loadingManager.loadableState == .none ? 0 : 2)
                .disabled(loadingManager.loadableState != .none)
//                .overlay(
//                    Group {
//                        if loadingManager.loadableState != .none {
            DMLoadingView(loadingManager: loadingManager,
                          settingsProvider: settingsProvider)
//                        }
//                    }
//                )
        }
    }
}
