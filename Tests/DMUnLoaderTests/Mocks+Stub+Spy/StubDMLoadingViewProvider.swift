//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import SwiftUI
import XCTest
import Combine
@testable import DMUnLoader

final class StubDMLoadingViewProvider: @MainActor DMLoadingViewProvider {
    typealias LoadingViewType = Text
    typealias ErrorViewType = Text
    typealias SuccessViewType = Text
    
    @MainActor
    func getLoadingView() -> LoadingViewType {
        Text("Stub Loading View")
    }

    @MainActor
    func getErrorView(error: Error, onRetry: DMAction?, onClose: DMAction) -> ErrorViewType {
        Text("Stub Error View")
    }

    @MainActor
    func getSuccessView(object: DMLoadableTypeSuccess) -> SuccessViewType {
        Text("Stub Success View")
    }

    var loadingManagerSettings: DMLoadingManagerSettings {
        StubDMLoadingManagerSettings(autoHideDelay: .seconds(2))
    }

    var loadingViewSettings: DMProgressViewSettings {
        StubDMProgressViewSettings()
    }

    var errorViewSettings: DMErrorViewSettings {
        StubDMErrorViewSettings()
    }

    var successViewSettings: DMSuccessViewSettings {
        StubDMSuccessViewSettings()
    }
}
