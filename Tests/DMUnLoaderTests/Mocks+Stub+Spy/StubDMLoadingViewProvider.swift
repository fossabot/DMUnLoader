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
    typealias LoadingViewType = StubDMLoadingViewResult<Text>
    typealias ErrorViewType = StubDMLoadingViewResult<Text>
    typealias SuccessViewType = StubDMLoadingViewResult<Text>
    
    @MainActor
    func getLoadingView() -> LoadingViewType {
        StubDMLoadingViewResult {
            Text("Stub Loading View")
        }
    }
    
    @MainActor
    func getErrorView(error: Error, onRetry: DMAction?, onClose: DMAction) -> ErrorViewType {
        StubDMLoadingViewResult {
            Text("Stub Error View")
        }
    }
    
    @MainActor
    func getSuccessView(object: DMLoadableTypeSuccess) -> SuccessViewType {
        StubDMLoadingViewResult {
            Text("Stub Success View")
        }
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
    
    struct StubDMLoadingViewResult<Content: View>: View {
        @ViewBuilder let content: () -> Content
        
        init(_ content: @escaping () -> Content) {
            self.content = content
        }
        
        var body: some View {
            content()
                .background(Color.orange.opacity(0.3))
                .border(Color.orange, width: 1)
        }
    }
}
