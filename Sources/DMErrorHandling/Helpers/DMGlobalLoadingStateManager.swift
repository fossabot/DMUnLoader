//
//  DMGlobalLoadingStateManager.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 01.02.2025.
//

import Combine

internal final class GlobalLoadingStateManager: ObservableObject, Observable {
    @Published var loadableState: DMLoadableType = .none
    
    var isLoading: Bool {
        loadableState == .loading
    }
    
    private var loadingManagerCancellables: [UUID: AnyCancellable] = [:]

    @MainActor
    func subscribeToLoadingManagers(_ loadingManagers: DMLoadingManager...) {
        // Subscribes to each of DMLoadingManager's object
        loadingManagers.forEach { manager in
            let cancellable = manager.loadableStatePublisher
                .sink { [weak self] state in
                    self?.loadableState = state
                }
            loadingManagerCancellables[manager.id] = cancellable
        }
    }
    
    func unsubscribeFromLoadingManager(_ manager: DMLoadingManager) {
        loadingManagerCancellables[manager.id] = nil
    }
}
