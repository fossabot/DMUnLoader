//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import XCTest
@testable import DMUnLoader
import SwiftUI

protocol DMLoadingViewProviderTDD: ObservableObject, Hashable {
    associatedtype LoadingViewType: View
    associatedtype ErrorViewType: View
    associatedtype SuccessViewType: View
    
    func getLoadingView() -> LoadingViewType
    func getErrorView(error: Error, onRetry: DMAction?, onClose: DMAction) -> ErrorViewType
    func getSuccessView(object: DMLoadableTypeSuccess) -> SuccessViewType

    var loadingManagerSettings: DMLoadingManagerSettings { get }
    var loadingViewSettings: DMLoadingViewSettings { get }
    var errorViewSettings: DMErrorViewSettings { get }
    var successViewSettings: DMSuccessViewSettings { get }
}

extension DMLoadingViewProviderTDD {
    static func == (lhs: Self,
                    rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(String.pointer(self))
    }
}

extension DMLoadingViewProviderTDD {
    
    @MainActor
    func getLoadingView() -> some View {
        DMProgressView(settings: loadingViewSettings)
    }
    
    @MainActor
    func getErrorView(error: Error,
                      onRetry: DMAction?,
                      onClose: DMAction) -> some View {
        DMErrorView(settings: errorViewSettings,
                    error: error,
                    onRetry: onRetry,
                    onClose: onClose)
    }
    
    @MainActor
    func getSuccessView(object: DMLoadableTypeSuccess) -> some View {
        DMSuccessView(settings: successViewSettings,
                      assosiatedObject: object)
    }
    
    // MARK: - Default Settings
    
    var loadingManagerSettings: DMLoadingManagerSettings {
        DMLoadingManagerDefaultSettings()
    }
    
    var loadingViewSettings: DMLoadingViewSettings {
        DMLoadingDefaultViewSettings()
    }
    
    var errorViewSettings: DMErrorViewSettings {
        DMErrorDefaultViewSettings()
    }
    
    var successViewSettings: DMSuccessViewSettings {
        DMSuccessDefaultViewSettings()
    }
}

class DefaultDMLoadingViewProviderTDD: @MainActor DMLoadingViewProviderTDD {
    let loadingManagerSettings: DMLoadingManagerSettings
    let loadingViewSettings: DMLoadingViewSettings
    let errorViewSettings: DMErrorViewSettings
    let successViewSettings: DMSuccessViewSettings
    
    init(
        loadingManagerSettings: DMLoadingManagerSettings? = nil,
        loadingViewSettings: DMLoadingViewSettings? = nil,
        errorViewSettings: DMErrorViewSettings? = nil,
        successViewSettings: DMSuccessViewSettings? = nil
    ) {
        self.loadingManagerSettings = loadingManagerSettings ?? DMLoadingManagerDefaultSettings()
        self.loadingViewSettings = loadingViewSettings ?? DMLoadingDefaultViewSettings()
        self.errorViewSettings = errorViewSettings ?? DMErrorDefaultViewSettings()
        self.successViewSettings = successViewSettings ?? DMSuccessDefaultViewSettings()
    }
}

struct MockProgressView: View {
    let settingsProvider: DMLoadingViewSettings
    
    init(settings settingsProvider: DMLoadingViewSettings) {
        self.settingsProvider = settingsProvider
    }
    
    var body: some View {
        Text("I'm a Progress View Test")
    }
}

struct MockErrorView: View {
    let settingsProvider: DMErrorViewSettings
    let error: Error
    let onRetry: DMAction?
    let onClose: DMAction
    
    init(settings settingsProvider: DMErrorViewSettings,
         error: Error,
         onRetry: DMAction? = nil,
         onClose: DMAction) {
        self.settingsProvider = settingsProvider
        self.error = error
        self.onRetry = onRetry
        self.onClose = onClose
    }
    
    var body: some View {
        Text("I'm a Error View Test")
    }
}

struct MockSuccessView: View {
    let settingsProvider: DMSuccessViewSettings
    let assosiatedObject: DMLoadableTypeSuccess?
    
    init(settings settingsProvider: DMSuccessViewSettings,
         assosiatedObject: DMLoadableTypeSuccess? = nil) {
        self.settingsProvider = settingsProvider
        self.assosiatedObject = assosiatedObject
    }
    
    var body: some View {
        Text("I'm a Success View Test")
    }
}

final class DMLoadingViewProviderTests_TDD: XCTestCase {
    
    @MainActor
    func testVerifyDefaultInitialization() {
        let sut = DefaultDMLoadingViewProviderTDD()
        
        XCTAssertTrue(
            sut.loadingManagerSettings is DMLoadingManagerDefaultSettings,
            "Default loadingManagerSettings should be of type DMLoadingManagerDefaultSettings."
        )
        XCTAssertTrue(
            sut.loadingViewSettings is DMLoadingDefaultViewSettings,
            "Default loadingViewSettings should be of type DMLoadingDefaultViewSettings."
        )
        XCTAssertTrue(
            sut.errorViewSettings is DMErrorDefaultViewSettings,
            "Default errorViewSettings should be of type DMErrorDefaultViewSettings."
        )
        XCTAssertTrue(
            sut.successViewSettings is DMSuccessDefaultViewSettings,
            "Default successViewSettings should be of type DMSuccessDefaultViewSettings."
        )
    }
    
    @MainActor
    func testVerifyHashableConformance() {
        let sut1 = DefaultDMLoadingViewProviderTDD()
        let sut2 = DefaultDMLoadingViewProviderTDD()
        
        XCTAssertNotEqual(sut1, sut2, "Two different instances should have different hash.")
        XCTAssertEqual(sut1, sut1, "Same instance should have different hash.")
    }
    
    @MainActor
    func testVerifyCustomizationViaSettings() {
        let sut = DefaultDMLoadingViewProviderTDD()
        
        checkVerifyCustomizationViaSettingsForProgressView(sut: sut)
        checkVerifyCustomizationViaSettingsForErrorView(sut: sut)
        checkVerifyCustomizationViaSettingsForSuccessView(sut: sut)
    }
    
    @MainActor
    private func checkVerifyCustomizationViaSettingsForProgressView<SUT: DMLoadingViewProviderTDD>(
        sut: SUT,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let loadingView = sut.getLoadingView() as? DMProgressView
        XCTAssertNotNil(
            loadingView,
            "Loading view should be of type DMProgressView.",
            file: file,
            line: line
        )
        
        let settings = loadingView?.settingsProvider as? DMLoadingDefaultViewSettings
        XCTAssertNotNil(
            settings,
            "Loading view settings should be of type DMLoadingDefaultViewSettings.",
            file: file,
            line: line
        )
        
        XCTAssertEqual(
            settings,
            sut.loadingViewSettings as? DMLoadingDefaultViewSettings,
            "Loading view settings should match the provider's loadingViewSettings.",
            file: file,
            line: line
        )
    }
    
    @MainActor
    private func checkVerifyCustomizationViaSettingsForErrorView<SUT: DMLoadingViewProviderTDD>(
        sut: SUT,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let errorView = sut.getErrorView(
            error: NSError(domain: "Test", code: 404),
            onRetry: nil,
            onClose: DMButtonAction {}
        ) as? DMErrorView
        
        XCTAssertNotNil(
            errorView,
            "Error view should be of type DMErrorView.",
            file: file,
            line: line
        )
        
        let settingsFromView = errorView?.settingsProvider as? DMErrorDefaultViewSettings
        XCTAssertNotNil(
            settingsFromView,
            "Error view settings should be of type DMErrorDefaultViewSettings.",
            file: file,
            line: line
        )
        let settingsFromProvider = sut.errorViewSettings as? DMErrorDefaultViewSettings
        XCTAssertNotNil(
            settingsFromProvider,
            "Error view settings from provider should be of type DMErrorDefaultViewSettings.",
            file: file,
            line: line
        )
        
        XCTAssertEqual(
            settingsFromView,
            settingsFromProvider,
            "Error view settings should match the provider's errorViewSettings.",
            file: file,
            line: line
        )
    }
    
    @MainActor
    private func checkVerifyCustomizationViaSettingsForSuccessView<SUT: DMLoadingViewProviderTDD>(
        sut: SUT,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let successView = sut.getSuccessView(object: "Some object") as? DMSuccessView
        
        XCTAssertNotNil(
            successView,
            "Success view should be of type DMSuccessView.",
            file: file,
            line: line
        )
        
        let settingsFromView = successView?.settingsProvider as? DMSuccessDefaultViewSettings
        XCTAssertNotNil(
            settingsFromView,
            "Success view settings should be of type DMSuccessDefaultViewSettings.",
            file: file,
            line: line
        )
        let settingsFromProvider = sut.successViewSettings as? DMSuccessDefaultViewSettings
        XCTAssertNotNil(
            settingsFromProvider,
            "Success view settings from provider should be of type DMSuccessDefaultViewSettings.",
            file: file,
            line: line
        )
        
        XCTAssertEqual(
            settingsFromView,
            settingsFromProvider,
            "Success view settings should match the provider's successViewSettings.",
            file: file,
            line: line
        )
    }
}
