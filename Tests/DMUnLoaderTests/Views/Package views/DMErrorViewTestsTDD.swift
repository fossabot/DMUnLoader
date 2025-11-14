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
        
        if let errorText = settingsProvider.errorText {
            Text(errorText)
                .tag(DMErrorViewOwnSettings.errorTextViewTag)
        }
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
        
        try checkErrorTextCorrespondsToSettings(
            sut: sut,
            expectedTextFromSettings: defaultSettings.errorText,
            expectedTextString: "An error has occured!"
        )
        try checkErrorTextCorrespondsToSettings(
            sut: sut,
            expectedTextFromSettings: nil,
            expectedTextString: nil
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
    
    private func checkErrorTextCorrespondsToSettings(
        sut: DMErrorViewTDD,
        expectedTextFromSettings: String?,
        expectedTextString: String?
    ) throws {
        guard expectedTextFromSettings?.isEmpty == false
                || expectedTextString?.isEmpty == false else {
            return
        }
        
        // When
        let text = try sut
            .inspect()
            .find(viewWithTag: DMErrorViewOwnSettings.errorTextViewTag)
            .text()

        // Then
        let textFormSUT = try? text.string()
        XCTAssertEqual(textFormSUT,
                       expectedTextFromSettings,
                       "The \(sut.self) text should match the settings")
        
        XCTAssertEqual(textFormSUT,
                       expectedTextString,
                       "The \(sut.self) text should match the expected text: `\(String(describing: expectedTextString))`")
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
