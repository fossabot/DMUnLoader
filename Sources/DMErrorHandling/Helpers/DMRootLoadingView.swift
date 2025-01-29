//
//  DMRootLoadingView.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 24.01.2025.
//

import SwiftUICore

public struct DMRootLoadingView<Content: View>: View {
    @StateObject private var loadingManager: DMLoadingManager
    @StateObject private var provider: BaseDMLoadingViewProvider
    
    private let content: () -> Content
    
    public init(
        provider: BaseDMLoadingViewProvider = BaseDMLoadingViewProvider(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        _loadingManager = StateObject(wrappedValue: DMLoadingManager())
        _provider = StateObject(wrappedValue: provider)
        self.content = content
    }
    
    public var body: some View {
        return content()
//            .environmentObject(loadingManager)
//            .environmentObject(provider)
        
            .autoLoading(manager: loadingManager,
                         providerViews: provider)
    }
}
