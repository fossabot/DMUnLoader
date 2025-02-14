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
    
    func testAutoLoading() throws {
//        // Create mocks
//        let loadingManager = MockDMLoadingManager()
//        let provider = MockDMLoadingViewProvider()
//
//        // Create a test view
//        let testView = EnvironmentAutoLoadingTestView()
//            .autoLoading(loadingManager,
//                         provider: provider)
//
//        // Inspect the view hierarchy
//        let inspectedView = try testView.inspect()
//        
//        let expectation = inspectedView.on(\.didAppear) { view in
//            _ = try view.find(ChildView.self).actualView().anObject
//        }
//        
//        ViewHosting.host(view: testView)
//        wait(for: [expectation], timeout: 1)
//        
////        try view.inspect().view(EnvironmentStateTestView.self).actualView().viewModel
//        let testActualView = try inspectedView.view(EnvironmentAutoLoadingTestView.self).actualView()
//        
//        let environmentLoadingManager = testActualView.loadingManager
//        XCTAssertNotNil(environmentLoadingManager, "DMLoadingManager should be available in the environment")
//        
//        let environmentProvider = testActualView.provider
//        XCTAssertNotNil(environmentProvider, "DMLoadingViewProvider should be available in the environment")
//        
////        // Check if the modifier is applied
////        let modifier = try inspectedView.find(ViewType.Modifier<DMLoadingModifier>.self)
////        XCTAssertNotNil(modifier, "DMLoadingModifier should be applied")
//
//        
//        
////        // Check if the loadingManager is available in the environment
////        let environmentLoadingManager: MockDMLoadingManager? = try inspectedView.environmentObject(as: MockDMLoadingManager.self)
////        XCTAssertNotNil(environmentLoadingManager, "DMLoadingManager should be available in the environment")
////
////        // Check if the provider is available in the environment
////        let environmentProvider: MockDMLoadingViewProvider? = try inspectedView.environmentObject(as: MockDMLoadingViewProvider.self)
////        XCTAssertNotNil(environmentProvider, "DMLoadingViewProvider should be available in the environment")
////
////        // Check if the modifier is applied
////        let modifier = try inspectedView.find(ViewType.Modifier<DMLoadingModifier>.self)
////        XCTAssertNotNil(modifier, "DMLoadingModifier should be applied")
    }
    
    func testSubscribeToGlobalLoadingManagers() {
        
        let provider = MockDMLoadingViewProvider()
        let localManager = DMLoadingManager(state: .none, settings: provider.loadingManagerSettings)
        let globalManager = GlobalLoadingStateManager()
        
        // Create mocks
//        let localManager = MockDMLoadingManager()
//        let globalManager = MockGlobalLoadingStateManager(loadableState: .none,
//                                                          subscribeToLoadingManagers: { managers in
//        },
//                                                          unsubscribeFromLoadingManager: { manager in
//            
//        })

        // Call the function
        Text("Test View").subscribeToGloabalLoadingManagers(localManager: localManager, globalManager: globalManager)

        // Verify subscription
        XCTAssertFalse(globalManager.isLoading, "Global manager should reflect the initial state of the local manager")
        
        // Trigger a state change in the local manager
        localManager.showLoading()
        
        XCTAssertTrue(globalManager.isLoading, "Global manager should reflect the loading state of the local manager")
    }
    
    func testUnsubscribeFromLoadingManager() {
//        // Create mocks
//        let localManager = MockDMLoadingManager()
//        let globalManager = MockGlobalLoadingStateManager()
        
        let provider = MockDMLoadingViewProvider()
        let localManager = DMLoadingManager(state: .none, settings: provider.loadingManagerSettings)
        let globalManager = GlobalLoadingStateManager()

        // Subscribe first
        globalManager.subscribeToLoadingManagers(localManager)
        XCTAssertTrue(globalManager.isLoading == false, "Global manager should reflect the initial state of the local manager")
        
        // Trigger a state change in the local manager
        localManager.showLoading()
        XCTAssertTrue(globalManager.isLoading, "Global manager should reflect the loading state of the local manager")

        // Unsubscribe
        let lastGlobalManagerStatusBeforeUnscribe = globalManager.isLoading
        Text("Test View").unsubscribeFromLoadingManager(localManager: localManager, globalManager: globalManager)
        
        // Trigger another state change in the local manager
        localManager.hide()
        XCTAssertEqual(lastGlobalManagerStatusBeforeUnscribe,
                       globalManager.isLoading,
                       "Global manager should no longer reflect changes after unsubscribing")
        
        XCTAssertNotEqual(localManager.loadableState,
                          globalManager.loadableState,
                          "Global manager and Local manager statuses can't be the same after unsubscribing")
    }
    
    func testUnsubscribeFromLoadingManagerWithoutGlobalManager() {
        // Create mocks
        let localManager = MockDMLoadingManager()
        let globalManager: MockGlobalLoadingStateManager? = nil

        // Call the function without a global manager
        Text("Test View").unsubscribeFromLoadingManager(localManager: localManager,
                                                        globalManager: globalManager)

        // No crash should occur, and a log message should be printed
        // You can use a logging framework or XCTestExpectation to capture the log message if needed.
    }

    func testSubscribeToGlobalLoadingManagersWithoutGlobalManager() {
        // let provider = MockDMLoadingViewProvider()
        // let localManager = DMLoadingManager(state: .none, settings: provider.loadingManagerSettings)
        // let globalManager = GlobalLoadingStateManager()
        
        // Create mocks
        let localManager = MockDMLoadingManager()
        let globalManager = MockGlobalLoadingStateManager(loadableState: .none,
                                                          subscribeToLoadingManagers: { managers in
        },
                                                          unsubscribeFromLoadingManager: { manager in
            
        })
        
        // Call the function without a global manager
        Text("Test View").subscribeToGloabalLoadingManagers(localManager: localManager,
                                                            globalManager: globalManager)

        // No crash should occur, and a log message should be printed
        // You can use a logging framework or XCTestExpectation to capture the log message if needed.
    }
    
//    func testRootLoading() throws {
//        // Create a mock global manager
////        let globalManager = MockGlobalLoadingStateManager(loadableState: .none,
////                                                          subscribeToLoadingManagers: { managers in
////        },
////                                                          unsubscribeFromLoadingManager: { manager in
////            
////        })
//        
//        let globalManager = GlobalLoadingStateManager()
//
//        // Create a test view
//        let testView = Text("Test View")
//            .rootLoading(globalManager: globalManager)
//
//        // Inspect the view hierarchy
//        let inspectedView = try testView.inspect()
//
//        // Check if the global manager is available in the environment
//        let environmentGlobalManager: GlobalLoadingStateManager? = try inspectedView.actualView().environmentObject()
//        XCTAssertNotNil(environmentGlobalManager, "GlobalLoadingStateManager should be available in the environment")
//
//        // Check if the modifier is applied
//        let modifier = try inspectedView.find(ViewType.Modifier<DMRootLoadingModifier>.self)
//        XCTAssertNotNil(modifier, "DMRootLoadingModifier should be applied")
//    }
}

private struct EnvironmentAutoLoadingTestView: View {
    
    @EnvironmentObject var loadingManager: MockDMLoadingManager
    @EnvironmentObject var provider: MockDMLoadingViewProvider
    
    var body: some View {
        Text("Test EnvironmentAutoLoadingTestView")
    }
}
