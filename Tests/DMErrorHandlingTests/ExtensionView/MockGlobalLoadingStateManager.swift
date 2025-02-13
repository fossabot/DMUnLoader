//
//  MockGlobalLoadingStateManager.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 13.02.2025.
//

import Foundation
import Combine
@testable import DMErrorHandling

@MainActor
final class MockGlobalLoadingStateManager/*: GlobalLoadingStateManagerInternalProtocol*/ {
    @Published public var loadableState: DMLoadableType = .none
    
    var isLoading: Bool {
        return loadableState == .loading
    }
    
    private let subscribeToLoadingManagersBlock: (_ loadingManagers: [DMLoadingManager]) -> Void
    private let unsubscribeFromLoadingManagerBlock: (_ manager: DMLoadingManager) -> Void
    
    init(loadableState: DMLoadableType,
         subscribeToLoadingManagers: @escaping (_ loadingManagers: [DMLoadingManager]) -> Void,
         unsubscribeFromLoadingManager: @escaping (_ manager: DMLoadingManager) -> Void) {
        
        self.loadableState = loadableState
        self.subscribeToLoadingManagersBlock = subscribeToLoadingManagers
        self.unsubscribeFromLoadingManagerBlock = unsubscribeFromLoadingManager
    }
    
    func subscribeToLoadingManagers(_ loadingManagers: DMLoadingManager...) {
        subscribeToLoadingManagersBlock(loadingManagers)
    }
    
    func unsubscribeFromLoadingManager(_ manager: DMLoadingManager) {
        unsubscribeFromLoadingManagerBlock(manager)
    }
}
