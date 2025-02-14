//
//  DMLoadingModifier.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 24.01.2025.
//

import SwiftUICore
import Combine

/// Modifier to add LoadingView to any View
internal struct DMLoadingModifier<Provider: DMLoadingViewProviderProtocol,
                                  LLM: DMLoadingManagerInteralProtocol>: ViewModifier {
    @ObservedObject internal var loadingManager: LLM
    
    internal var provider: Provider
    
    public func body(content: Content) -> some View {
        let isLoading = loadingManager.loadableState != .none
        
        return ZStack {
            content
                .blur(radius: isLoading ? 2 : 0)
                .disabled(isLoading)
            
            DMLoadingView(loadingManager: loadingManager,
                          provider: provider)
        }
    }
}
