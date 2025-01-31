//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI

public extension View {
    func autoLoading<Provider: DMLoadingViewProvider>(_ loadingManager: DMLoadingManager,
                                                      provider: Provider) -> some View {
        self
            .environmentObject(loadingManager)
            .environmentObject(provider)
            .modifier(DMLoadingModifier(loadingManager: loadingManager, provider: provider))
    }
    
//    func autoLoadingNew<Provider: DMLoadingViewProvider>(_ loadingManager: DMLoadingManager,
//                                                         provider: Provider,
//                                                         id: UUID) -> some View {
//        self
//            .environmentObject(loadingManager)
//            .environmentObject(provider)
//            .modifier(DMLoadingModifier(loadingManager: loadingManager, provider: provider))
//    }
}
