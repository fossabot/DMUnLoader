//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest

public enum DMLoadableState {
    case idle
    case loading
    case success
    case error(Error)
}

public class LoadingManager {
    private(set) var currentState: DMLoadableState
    
    public init(withState state: DMLoadableState) {
        self.currentState = state
    }
}

final class LoadingManagerUseCaseTests: XCTestCase {

    func test_init_LoadingManagerInitiatedInIdleState() {
        let sut = LoadingManager(withState: .idle)
        
        XCTAssertEqual(sut.currentState, .idle, "LoadingManager should be initialized in idle state")
    }
}

extension DMLoadableState: Equatable {
    public static func == (lhs: DMLoadableState, rhs: DMLoadableState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        default:
            return false
        }
    }
}
