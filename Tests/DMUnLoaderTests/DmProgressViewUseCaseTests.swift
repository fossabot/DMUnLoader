//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest
import ViewInspector
@testable import DMUnLoader
import SwiftUICore

@MainActor
final class DmProgressViewUseCaseTests: XCTestCase {

    // MARK: Default Settings
    func test_progressView_VerifyDefaultInitialization_viewContainsProgressView() throws {
        
        let sut = makeSUT()
        
        let progressView = try sut
            .inspect()
            .find(viewWithTag: DMProgressViewOwnSettings.progressViewTag)
            .progressView()
        XCTAssertNotNil(progressView,
                        "The ProgressView should be rendered")
    }
    
    func test_progressView_VerifyDefaultInitialization_ProgressViewDefaultTextIsCorrect() throws {
        let sut = makeSUT()
        
        let text = try sut
            .inspect()
            .find(viewWithTag: DMProgressViewOwnSettings.textTag)
            .text()
        XCTAssertEqual(try text.string(),
                       "Loading...",
                       "The Text view should display the correct text")
    }
    
    func test_progressView_VerifyDefaultInitialization_defaultTintColorOfTheProgressIndicatorIsCorrect() throws {
        let sut = makeSUT()
       
        let progressView = try sut
            .inspect()
            .find(viewWithTag: DMProgressViewOwnSettings.progressViewTag)
            .progressView()
        
        XCTAssertEqual(try progressView.tint(),
                       .white,
                       "The ProgressView should have the correct tint color")
    }
    
    // MARK: Custom Settings
    
    func test_progressView_VerifyCustomSettings_CustomSettingWereApplied() throws {
        let sut = makeSUT(withSettings: ViewSettingsHelper.makeLoadingCustomSettings())
        
        let text = try sut
            .inspect()
            .find(viewWithTag: DMProgressViewOwnSettings.textTag)
            .text()
        
        XCTAssertEqual(try text.string(),
                       "Processing...",
                       "The Text view should display the correct text")
        XCTAssertEqual(try text.attributes().foregroundColor(),
                       .orange,
                       "The Text view should have the correct foreground color")
        XCTAssertEqual(try text.attributes().font(),
                       Font.title3,
                       "The Text view should have the correct font")
        XCTAssertEqual(try text.lineLimit(),
                       2,
                       "The Text view should have the correct line limit")
        XCTAssertEqual(try text.padding(.horizontal),
                       10,
                       "The Text view should have the correct padding")
    }
    
    // MARK: - HELPERs
    
    private func makeSUT(
        withSettings settings: DMLoadingViewSettings = DMLoadingDefaultViewSettings()
    ) -> DMProgressView {
        
        DMProgressView(settings: settings)
    }
}
