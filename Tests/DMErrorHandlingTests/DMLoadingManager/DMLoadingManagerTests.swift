//
//  DMLoadingManagerTests.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 13.02.2025.
//

import XCTest
import Combine
@testable import DMErrorHandling

final class DMLoadingManagerTests: XCTestCase {
        
    var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // Test 1: Initialization
    @MainActor
    func testInitialization() {
        let settings = MockDMLoadingManagerSettings()
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Ensure that the initial state is `.none`
        XCTAssertEqual(manager.loadableState,
                       .none,
                       "Initial loadableState should be .none")
    }
    
    // Test 2: Show Loading State
    @MainActor
    func testShowLoading() throws {
        let expectation = XCTestExpectation(description: "Loadable state updated to .loading")
        
        let secondsAutoHideDelay: Double = 0.2
        let settings = MockDMLoadingManagerSettings(autoHideDelay: .seconds(secondsAutoHideDelay))
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Observe changes to loadableState
        manager.$loadableState
            .dropFirst() // Skip the initial value
            .sink { state in
                XCTAssertEqual(state, .loading,
                               "loadableState should be updated to .loading")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger the showLoading method
        manager.showLoading()
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: secondsAutoHideDelay)
    }
    
    // Test 3: Show Success State
    @MainActor
    func testShowSuccess() throws {
        let expectation = XCTestExpectation(description: "Loadable state updated to .success")
        
        let secondsAutoHideDelay: Double = 0.2
        let settings = MockDMLoadingManagerSettings(autoHideDelay: .seconds(secondsAutoHideDelay))
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Observe changes to loadableState
        manager.$loadableState
            .dropFirst() // Skip the initial value
            .sink { state in
                if case .success(let message) = state {
                    XCTAssertEqual(message.description,
                                   "Test Message",
                                   "loadableState should be updated to .success with the correct message")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger the showSuccess method
        manager.showSuccess("Test Message")
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: secondsAutoHideDelay)
    }
    
    // Test 4: Show Failure State
    @MainActor
    func testShowFailure() throws {
        let expectation = XCTestExpectation(description: "Loadable state updated to .failure")
        
        let secondsAutoHideDelay: Double = 0.2
        let settings = MockDMLoadingManagerSettings(autoHideDelay: .seconds(secondsAutoHideDelay))
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Observe changes to loadableState
        manager.$loadableState
            .dropFirst() // Skip the initial value
            .sink { state in
                if case .failure(let error, _) = state {
                    XCTAssertEqual(error.localizedDescription,
                                   "Test Error",
                                   "loadableState should be updated to .failure with the correct error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger the showFailure method
        manager.showFailure(NSError(domain: "TestDomain",
                                    code: 1,
                                    userInfo: [NSLocalizedDescriptionKey: "Test Error"]))
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: secondsAutoHideDelay)
    }
    
    // Test 5: Inactivity Timer Hides State
    @MainActor
    func testInactivityTimerHidesStateEarlyHideExpectation() throws {
        let earlyHideExpectation = XCTestExpectation(description: "Loadable state should not hide earlier than 1.5 seconds")
        earlyHideExpectation.isInverted = true // This ensures the test fails if the expectation is fulfilled too early
        
        let secondsAutoHideDelay: Double = 0.2
        let settings = MockDMLoadingManagerSettings(autoHideDelay: .seconds(secondsAutoHideDelay))
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Trigger the showSuccess method to start the inactivity timer
        manager.showSuccess("Test Message")
        
        // Check that the state does not transition to `.none` before `\(secondsAutoHideDelay)` seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsAutoHideDelay - 0.1) {
            // If the state has already transitioned to `.none`, log a failure (optional)
            XCTAssertFalse(manager.loadableState == .none,
                           "Loadable state transitioned to .none before the expected delay of `\(secondsAutoHideDelay)` seconds")
        }
        
        wait(for: [earlyHideExpectation], timeout: secondsAutoHideDelay + 0.1) // Ensure no early fulfillment
        XCTAssertTrue(manager.loadableState == .none,
                       "Loadable state didn't transitioned to .none the expected delay of `\(secondsAutoHideDelay)` seconds")
    }
    
    @MainActor
    func testInactivityTimerHidesStateHideExpectation() throws {
        let hideExpectation = XCTestExpectation(description: "Loadable state hidden after inactivity timer")
        
        let secondsAutoHideDelay: Double = 0.2
        let settings = MockDMLoadingManagerSettings(autoHideDelay: .seconds(secondsAutoHideDelay))
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Observe changes to loadableState
        manager.$loadableState
            .dropFirst() // Skip the initial value
            .sink { state in
                if state == .none {
                    hideExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger the showSuccess method to start the inactivity timer
        manager.showSuccess("Test Message")
        
        // Wait for the expectations to be fulfilled
        wait(for: [hideExpectation], timeout: secondsAutoHideDelay+0.1) // Ensure the state hides after the timer
    }
    
    // Test 6: Stop Timer and Hide
    @MainActor
    func testStopTimerAndHide() throws {
        let expectation = XCTestExpectation(description: "Loadable state hidden after stopping timer")
        
        let secondsAutoHideDelay: Double = 0.2
        let settings = MockDMLoadingManagerSettings(autoHideDelay: .seconds(secondsAutoHideDelay))
        let manager = DMLoadingManager(state: .none, settings: settings)
        
        // Observe changes to loadableState
        manager.$loadableState
            .dropFirst() // Skip the initial value
            .sink { state in
                if state == .none {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger the showSuccess method to start the inactivity timer
        manager.showSuccess("Test Message")
        
        // Stop the timer and hide manually
        manager.stopTimerAndHide()
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: secondsAutoHideDelay)
    }
}
