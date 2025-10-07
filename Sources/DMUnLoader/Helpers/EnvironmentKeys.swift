import SwiftUI

// MARK: - EnvironmentKey for Loading Provider

struct LoadingViewProviderKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any DMLoadingViewProviderProtocol = DefaultDMLoadingViewProvider()
}

public extension EnvironmentValues {
    var loadingViewProvider: any DMLoadingViewProviderProtocol {
        get { self[LoadingViewProviderKey.self] }
        set { self[LoadingViewProviderKey.self] = newValue }
    }
}
