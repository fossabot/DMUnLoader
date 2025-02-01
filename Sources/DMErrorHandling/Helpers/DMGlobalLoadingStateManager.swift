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

    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func subscribeToLoadingManagers(_ loadingManagers: DMLoadingManager...) {
        // Subscribes to each of DMLoadingManager's object
        loadingManagers.forEach { manager in
            manager.loadableStatePublisher
                //.combineLatest ?
                .sink { [weak self] state in
                    self?.loadableState = state
                }
                .store(in: &cancellables)
        }
    }
}
