//
//  RootLoadingView.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 24.01.2025.
//

import SwiftUICore

public struct RootLoadingView<Content: View>: View {
    @StateObject private var loadingManager = LoadingManager()
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(loadingManager)
            .autoLoading(loadingManager) // Автоматичне додавання оверлею
    }
}
