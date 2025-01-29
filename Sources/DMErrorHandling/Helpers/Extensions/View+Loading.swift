//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI

public extension View {
    
    func autoLoading(manager loadingManager: DMLoadingManager,
                     providerViews provider: BaseDMLoadingViewProvider) -> some View {
        self
            .environmentObject(loadingManager)
            .environmentObject(provider)
            .modifier(DMLoadingModifier(loadingManager: loadingManager,
                                        settingsProvider: provider))
    }
}
