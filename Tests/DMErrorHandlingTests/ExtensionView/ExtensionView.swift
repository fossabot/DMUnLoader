//
//  Test.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 13.02.2025.
//

import SwiftUI
import XCTest
@testable import DMErrorHandling
import ViewInspector

@MainActor // Ensure all tests run on the main actor
final class ExtensionViewTests: XCTestCase {
    
//    func testAutoLoading() throws {
//        // Create mocks
//        let provider = MockDMLoadingViewProvider()
//        let loadingManager = DMLoadingManager(state: .none,
//                                              settings: provider.loadingManagerSettings)
//        
//        // Create a test view
//        let testView = Text("Test View")
//            .autoLoading(loadingManager, provider: provider)
//
//        // Inspect the view hierarchy
//        let inspectedView = try testView.inspect()
//
//        // Check if the loadingManager is available in the environment
//        let environmentLoadingManager: DMLoadingManager? = try inspectedView.environmentObject()
//        XCTAssertNotNil(environmentLoadingManager, "DMLoadingManager should be available in the environment")
//
//        // Check if the provider is available in the environment
//        let environmentProvider: MockDMLoadingViewProvider? = try inspectedView.environmentObject()
//        XCTAssertNotNil(environmentProvider, "DMLoadingViewProvider should be available in the environment")
//
//        // Check if the modifier is applied
//        let modifier = try inspectedView.find(ViewType.Modifier<DMLoadingModifier>.self)
//        XCTAssertNotNil(modifier, "DMLoadingModifier should be applied")
//    }
    
    func testSubscribeToGlobalLoadingManagers() {
        // Create mocks
        let provider = MockDMLoadingViewProvider()
        let localManager = DMLoadingManager(state: .none, settings: provider.loadingManagerSettings)
//        let globalManager = MockGlobalLoadingStateManager()
        let globalManager = GlobalLoadingStateManager()

        // Call the function
        Text("Test View").subscribeToGloabalLoadingManagers(localManager: localManager, globalManager: globalManager)

        // Verify subscription
        XCTAssertTrue(globalManager.isLoading == false, "Global manager should reflect the initial state of the local manager")
        
        // Trigger a state change in the local manager
        localManager.showLoading()
        
        XCTAssertTrue(globalManager.isLoading, "Global manager should reflect the loading state of the local manager")
    }

    func testSubscribeToGlobalLoadingManagersWithoutGlobalManager() {
        // Create mocks
        let provider = MockDMLoadingViewProvider()
        let localManager = DMLoadingManager(state: .none, settings: provider.loadingManagerSettings)
//        let globalManager = MockGlobalLoadingStateManager(loadableState: .none,
//                                                          subscribeToLoadingManagers: { managers in
//        },
//                                                          unsubscribeFromLoadingManager:  { manager in
//            
//        })
        let globalManager = GlobalLoadingStateManager()
        
        // Call the function without a global manager
        Text("Test View").subscribeToGloabalLoadingManagers(localManager: localManager,
                                                            globalManager: globalManager)

        // No crash should occur, and a log message should be printed
        // You can use a logging framework or XCTestExpectation to capture the log message if needed.
    }
}
