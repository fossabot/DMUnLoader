//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest
import DMUnLoader
import SwiftUICore

final class DMLoadingViewProviderUseCaseTests: XCTestCase {
    
    func test_defaultImplementation_providesUniqueID() {
        let sut1 = makeSUT()
        let sut2 = makeSUT()
        
        XCTAssertNotEqual(sut1.id, sut2.id, "Each LoadingViewProvider instance should have a unique ID")
    }
    
    // MARK: Settings
    func test_defaultImplementation_providesLoadingManagerSettings() {
        let sut = makeSUT()
        
        let settingsUT = sut.loadingManagerSettings
        let defaultSettings = DMLoadingManagerConfiguration.Settings.self
        XCTAssertEqual(settingsUT.autoHideDelay, defaultSettings.autoHideDelay)
    }
    
    func test_defaultImplementation_providesLoadingViewSettings() {
        let sut = makeSUT()
        
        let settingsUT = sut.loadingViewSettings
        let defaultSettings = DMLoadingDefaultViewSettings.Settings.self
        XCTAssertEqual(
            settingsUT.frameGeometrySize,
            defaultSettings.frameGeometrySize
        )
        XCTAssertEqual(
            settingsUT.loadingContainerForegroundColor,
            .primary
        )
        XCTAssertEqual(
            settingsUT.progressIndicatorProperties,
            defaultSettings.progressIndicatorProperties
        )
        XCTAssertEqual(
            settingsUT.loadingTextProperties,
            defaultSettings.loadingTextProperties
        )
    }
    
    func test_defaultImplementation_providesErrorViewSettings() {
        let sut = makeSUT()
        
        let settingsUT = sut.errorViewSettings
        let defaultSettings = DMErrorDefaultViewSettings.Settings.self
        XCTAssertEqual(
            settingsUT.errorText,
            defaultSettings.errorText
        )
        XCTAssertEqual(
            settingsUT.errorTextSettings,
            defaultSettings.errorTextSettings
        )
        XCTAssertEqual(
            settingsUT.actionButtonCloseSettings,
            defaultSettings.actionButtonCloseSettings
        )
        XCTAssertEqual(
            settingsUT.actionButtonRetrySettings,
            defaultSettings.actionButtonRetrySettings
        )
        XCTAssertEqual(
            settingsUT.errorImageSettings,
            defaultSettings.errorImageSettings
        )
    }
    
    func test_defaultImplementation_providesSuccessViewSettings() {
        let sut = makeSUT()
        
        let settingsUT = sut.successViewSettings
        let defaultSettings = DMSuccessDefaultViewSettings.Settings.self
        
        XCTAssertEqual(
            settingsUT.successImageProperties,
            defaultSettings.successImageProperties
        )
        XCTAssertEqual(
            settingsUT.successTextProperties,
            defaultSettings.successTextProperties
        )
    }
    
    // MARK: - Helpers
    private func makeSUT() -> LoadingViewProviderSpy {
        LoadingViewProviderSpy()
    }
}

extension ProgressIndicatorProperties: Equatable {
    public static func == (lhs: ProgressIndicatorProperties, rhs: ProgressIndicatorProperties) -> Bool {
        lhs.size == rhs.size && lhs.tintColor == rhs.tintColor
    }
}

extension LoadingTextProperties: Equatable {
    public static func == (lhs: LoadingTextProperties, rhs: LoadingTextProperties) -> Bool {
        lhs.text == rhs.text &&
        lhs.alignment == rhs.alignment &&
        lhs.foregroundColor == rhs.foregroundColor &&
        lhs.font == rhs.font &&
        lhs.lineLimit == rhs.lineLimit &&
        lhs.linePadding == rhs.linePadding
    }
}

extension ErrorTextSettings: Equatable {
    public static func == (lhs: ErrorTextSettings, rhs: ErrorTextSettings) -> Bool {
        lhs.foregroundColor == rhs.foregroundColor &&
        lhs.multilineTextAlignment == rhs.multilineTextAlignment &&
        lhs.padding == rhs.padding
    }
}

extension ActionButtonSettings: Equatable {
    public static func == (lhs: ActionButtonSettings, rhs: ActionButtonSettings) -> Bool {
        lhs.text == rhs.text &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.cornerRadius == rhs.cornerRadius
    }
}

extension ErrorImageSettings: Equatable {
    public static func == (lhs: ErrorImageSettings, rhs: ErrorImageSettings) -> Bool {
        lhs.image == rhs.image &&
        lhs.foregroundColor == rhs.foregroundColor &&
        lhs.frameSize == rhs.frameSize
    }
}

extension CustomSizeViewSettings: Equatable {
    public static func == (lhs: CustomSizeViewSettings, rhs: CustomSizeViewSettings) -> Bool {
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.alignment == rhs.alignment
    }
}

extension SuccessImageProperties: Equatable {
    public static func == (lhs: SuccessImageProperties, rhs: SuccessImageProperties) -> Bool {
        lhs.image == rhs.image &&
        lhs.frame == rhs.frame &&
        lhs.foregroundColor == rhs.foregroundColor
    }
}

extension SuccessTextProperties: Equatable {
    public static func == (lhs: SuccessTextProperties, rhs: SuccessTextProperties) -> Bool {
        lhs.text == rhs.text &&
        lhs.foregroundColor == rhs.foregroundColor
    }
}

private final class LoadingViewProviderSpy: DMLoadingViewProvider {
    var id: UUID
    
    init() {
        self.id = UUID()
    }
}
