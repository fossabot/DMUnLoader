//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest
@testable import DMUnLoader
import SwiftUI
import SnapshotTesting

struct DMLoadingView_TDD<LLM: DMLoadingManager>: View {
    @ObservedObject private(set) var loadingManager: LLM
    
    init(loadingManager: LLM) {
        self.loadingManager = loadingManager
    }
    
    var body: some View {
        let loadableState = loadingManager.loadableState
        switch loadableState {
        case .none:
            EmptyView()
                .tag(DMLoadingViewOwnSettings.emptyViewTag)
        default:
            EmptyView()
        }
    }
}

@MainActor
final class DMLoadingViewTests_TDD: XCTestCase {
    
    override func invokeTest() {
        withSnapshotTesting(
            record: .missing,
            diffTool: .ksdiff
        ) {
            super.invokeTest()
        }
    }
    
    // MARK: - Scenario 1: Verify Empty State (`.none`)
    
    func testLoadingView_ShowsEmptyStateWith_NoOverlayOrBackground_WhenLoadingStateIsNone() {
        // Given
        let loadingManager = StubDMLoadingManager(loadableState: .none)
        
        // When
        let sut = makeSUT(manager: loadingManager)
        
        // Then
        assertSnapshot(
            of: sut,
            as: .image(
                layout: .device(config: .iPhone13Pro),
                traits: .init(userInterfaceStyle: .light)
            ),
            named: "View-EmptyState-No-Overlay-or-Background-iPhone13Pro-light",
            record: false
        )

    }
    
    func testLoadingView_AssignTagFromSettingsToEmptyView_WhenLoadingStateIsNone() throws {
        // Given
        let loadingManager = StubDMLoadingManager(loadableState: .none)
        
        // When
        let sut = makeSUT(manager: loadingManager)
        let tagToFindTheView = DMLoadingViewOwnSettings.emptyViewTag
        let emptyView = try sut
            .inspect()
            .find(viewWithTag: tagToFindTheView)
        
        // Then
        XCTAssertNotNil(emptyView,
                        "The EmptyView should have the correct tag assigned from settings: `\(tagToFindTheView)`")
    }
    
    // MARK: - Helpers
    
    private func makeSUT<LM: DMLoadingManager>(manager loadingManager: LM) -> DMLoadingView_TDD<LM> {
        
        let sut = DMLoadingView_TDD(loadingManager: loadingManager)
        
        trackForMemoryLeaks(loadingManager)
        
        return sut
    }
    
}
