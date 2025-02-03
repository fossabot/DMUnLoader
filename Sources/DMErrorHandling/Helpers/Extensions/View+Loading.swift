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
    
    internal func subscribeToGloabalLoadingManagers(localManager localLoadingManager: DMLoadingManager,
                                                    globalManager globalLoadingManager: GlobalLoadingStateManager?) {
        guard let globalLoadingManager else {
            print("\(#function): @Environment(\\.gloabalLoadingManager) doesn't contains required value")
            return
        }
        
        globalLoadingManager.subscribeToLoadingManagers(localLoadingManager)
    }
    
    internal func unsubscribeFromLoadingManager(localManager localLoadingManager: DMLoadingManager,
                                                globalManager globalLoadingManager: GlobalLoadingStateManager?) {
        guard let globalLoadingManager else {
            print("\(#function): @Environment(\\.gloabalLoadingManager) doesn't contains required value")
            return
        }
        
        globalLoadingManager.unsubscribeFromLoadingManager(localLoadingManager)
    }
    
    internal func rootLoading(globalManager globalLoadingManager: GlobalLoadingStateManager) -> some View {
        self
            .environment(\.globalLoadingManager, globalLoadingManager)
            .modifier(DMRootLoadingModifier(globalLoadingStateManager: globalLoadingManager))
    }
}
