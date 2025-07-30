//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest
import Combine

public enum DMLoadableState: Sendable {
    case idle
    case loading
    case success
    case error(Error)
}

public protocol LoadingManager {
    var settings: DMLoadingManagerSettings { get }
    var currentState: DMLoadableState { get }
    func show(state: DMLoadableState)
    func hide()
}

public struct DMLoadingManagerSettings {
    public let autoHideDelay: Duration
    
    public init(autoHideDelay: Duration = .seconds(2)) {
        self.autoHideDelay = autoHideDelay
    }
}

public class DMLoadingManagerService: LoadingManager {
    public let settings: DMLoadingManagerSettings
    
    public var currentState: DMLoadableState {
        _currentState()
    }
    
    private var _currentState: Atomic<DMLoadableState>
    private var inactivityTimerCancellable: AnyCancellable?
    
    public init(withState state: DMLoadableState = .idle,
                settings: DMLoadingManagerSettings = DMLoadingManagerSettings()) {
        self._currentState = Atomic(state)
        self.settings = settings
    }
    
    public func show(state: DMLoadableState) {
        switch state {
        case .loading,
                .idle:
            stopInactivityTimer()
        default:
            startInactivityTimer()
        }
        
        _currentState.mutate { [state] prop in
            prop = state
        }
    }
    
    public func hide() {
        show(state: .idle)
    }
    
    // MARK: Timer Management
    
    /// Starts the inactivity timer, which automatically hides the loading state after the specified delay.
    private func startInactivityTimer() {
        stopInactivityTimer()
        inactivityTimerCancellable = Deferred {
            Future<Void, Never> { promise in
                promise(.success(()))
            }
        }
        .delay(for: .seconds(settings.autoHideDelay.timeInterval),
               scheduler: RunLoop.main)
        .sink(receiveValue: { [weak self] _ in
            self?.hide()
        })
    }
    
    /// Stops the inactivity timer, canceling any pending auto-hide operations.
    private func stopInactivityTimer() {
        inactivityTimerCancellable?.cancel()
        inactivityTimerCancellable = nil
    }
}

extension Duration {
    
    /// Converts the `Duration` value into a `TimeInterval` representation.
    /// - Returns: The total duration in seconds as a `TimeInterval`, including fractional seconds.
    /// - Note: This property combines the `seconds` and `attoseconds` components of the `Duration`
    ///   to calculate the precise time interval.
    /// - Example:
    ///   ```swift
    ///   let duration = Duration.seconds(2) + Duration.attoseconds(500_000_000_000_000_000)
    ///   let timeInterval = duration.timeInterval
    ///   print(timeInterval) // Output: 2.5
    ///   ```
    var timeInterval: TimeInterval {
        let seconds = Double(components.seconds)
        let attoseconds = Double(components.attoseconds) / 1_000_000_000_000_000_000
        return seconds + attoseconds
    }
}

final class LoadingManagerUseCaseTests: XCTestCase {

    func test_init_LoadingManagerInitiatedInIdleState() {
        let sut = DMLoadingManagerService(withState: .idle)
        XCTAssertEqual(sut.currentState, .idle, "LoadingManager should be initialized in idle state")
        
        let sut2 = DMLoadingManagerService()
        XCTAssertEqual(
            sut2.currentState,
            .idle,
            "LoadingManager should be initialized in idle state even if it's not provided explicitly"
        )
        
        let sut3 = makeSUT()
        XCTAssertEqual(sut3.currentState, .idle, "LoadingManager should be initialized in idle state")
    }
    
    func test_states_LoadingManagerIsDisplayesItsStatesInOrderOfIncome() {
        let sut = makeSUT()
        sut.show(state: .loading)
        sut.show(state: .idle)
        
        XCTAssertEqual(
            sut.states,
            [.loading, .idle],
            "LoadingManager should display states in the order they are received"
        )
    }
    
    func test_states_LoadingManagerIsDisplayesItsStatesInOrderOfIncomeInMultithreadingEnviroment() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "States should be displayed in order")
        
        let testConcurrentQueue = DispatchQueue(label: "com.test.concurrentQueue", attributes: .concurrent)

        expectation.expectedFulfillmentCount = 3
        
        testConcurrentQueue.async {
            sut.show(state: .loading)
            expectation.fulfill()
        }
        testConcurrentQueue.asyncAfter(deadline: .now() + 0.01) {
            sut.show(state: .idle)
            expectation.fulfill()
        }
        testConcurrentQueue.asyncAfter(deadline: .now() + 0.02) {
            sut.show(state: .error(anyError()))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
        
        XCTAssertEqual(
            sut.states,
            [
                .loading,
                .idle,
                .error(anyError())
            ],
            "LoadingManager should display states in the order they are received"
        )
    }
    
    func test_autoHideDelay_SettingsProvideTwoSecondsDelayByDefault() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.settings.autoHideDelay,
                       .seconds(2),
                       "Default autoHideDelay should be `2` seconds")
    }
        
    func test_currentState_IfItsNotIdleOrLoadingShouldResetToIdleStateAfterTimeInterval() {
        let secTimeInterval: Double = 0.001
        let sut = makeSUT(settings: DMLoadingManagerSettings(autoHideDelay: .seconds(secTimeInterval)))
        
        let states = [
            DMLoadableState.success,
            DMLoadableState.error(anyError())
        ]
            
        states.forEach { state in
            sut.show(state: state)
            
            let exp = XCTestExpectation(description: "Current state should reset to idle after delay")
            DispatchQueue.main.asyncAfter(deadline: .now() + secTimeInterval + 0.005) {
                exp.fulfill()
            }
            
            wait(for: [exp], timeout: secTimeInterval + 0.01)
            
            XCTAssertEqual(
                sut.currentState,
                .idle,
                "Current state `\(sut.currentState)` should reset to idle after delay when showing \(state)"
            )
        }
    }
    
    func test_currentState_IfItsIdleOrLoadingShouldNotResetToIdleStateAfterTimeInterval() {
        let secTimeInterval: Double = 0.001
        let sut = makeSUT(settings: DMLoadingManagerSettings(autoHideDelay: .seconds(secTimeInterval)))
        
        let states = [
            DMLoadableState.idle,
            DMLoadableState.loading
        ]
            
        states.forEach { state in
            sut.show(state: state)
            
            let exp = XCTestExpectation(description: "Current state should NOT reset to idle after delay")
            DispatchQueue.main.asyncAfter(deadline: .now() + secTimeInterval + 0.005) {
                exp.fulfill()
            }
            
            wait(for: [exp], timeout: secTimeInterval + 0.01)
            
            XCTAssertEqual(
                sut.currentState,
                state,
                "Current state `\(sut.currentState)` should NOT reset to idle after delay when showing \(state)"
            )
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(settings: DMLoadingManagerSettings = DMLoadingManagerSettings()) -> LoadingManagerSpy {
        LoadingManagerSpy(manager: DMLoadingManagerService(settings: settings))
    }
    
    private class LoadingManagerSpy: @unchecked Sendable, LoadingManager {
        var settings: DMLoadingManagerSettings {
            manager.settings
        }
        
        var currentState: DMLoadableState {
            manager.currentState
        }
        
        private let manager: LoadingManager
        private(set) var states = [DMLoadableState]()
        
        init(manager: LoadingManager) {
            self.manager = manager
        }
        
        public func show(state: DMLoadableState) {
            manager.show(state: state)
            self.states.append(state)
        }
        
        func hide() {
            manager.hide()
        }
    }
}

func anyError() -> Error {
    NSError(domain: "TestError", code: 0, userInfo: nil)
}


extension DMLoadableState: Equatable {
    public static func == (lhs: DMLoadableState, rhs: DMLoadableState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case let (.error(lhsError as NSError), .error(rhsError as NSError)):
            return lhsError.code == rhsError.code && lhsError.domain == rhsError.domain
        default:
            return false
        }
    }
}
