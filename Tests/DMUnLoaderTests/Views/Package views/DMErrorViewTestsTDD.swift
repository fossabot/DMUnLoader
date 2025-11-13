//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest
@testable import DMUnLoader
import SwiftUI
import ViewInspector

struct DMErrorViewTDD: View {
    let settingsProvider: DMErrorViewSettings
    
    init(settings settingsProvider: DMErrorViewSettings) {
        self.settingsProvider = settingsProvider
    }
    
    var body: some View {
        let imageSettings = settingsProvider.errorImageSettings
        
        imageSettings.image
            .tag(DMErrorViewOwnSettings.imageViewTag)
    }
}

@MainActor
final class DMErrorViewTestsTDD: XCTestCase {
    
    // MARK: Scenario 1: Verify Default Initialization
    func testInitializationWithDefaultSettings() throws {
        // Given
        let defaultSettings = DMErrorDefaultViewSettings()
        
        // When
        let sut = makeSUT(settings: defaultSettings)
        
        // Then
        try checkErrorViewImageCorrespondsToSettings(
            sut: sut,
            expectedImageSettings: defaultSettings.errorImageSettings
        )
    }
    
    private func checkErrorViewImageCorrespondsToSettings(
        sut: DMErrorViewTDD,
        expectedImageSettings: ErrorImageSettings
    ) throws {
        // When
        let image = try sut
            .inspect()
            .find(viewWithTag: DMErrorViewOwnSettings.imageViewTag)
            .image()

        // Then
        try sutImageNameConfirmToExpectedImage(
            sutImage: image,
            expectedImage: expectedImageSettings.image,
            expectedImageName: "exclamationmark.triangle"
        )
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        settings: DMErrorViewSettings
    ) -> DMErrorViewTDD {
        let sut = DMErrorViewTDD(
            settings: settings
        )
        
        return sut
    }
}
