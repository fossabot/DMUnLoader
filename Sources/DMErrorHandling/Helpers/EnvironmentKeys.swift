//
//  EnvironmentKeys.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 01.02.2025.
//

import SwiftUICore

//MARK: - GlobalLoadingManagerKey

internal struct GlobalLoadingManagerKey: EnvironmentKey {
    static let defaultValue: GlobalLoadingStateManager? = nil
}

internal extension EnvironmentValues {
    var globalLoadingManager: GlobalLoadingStateManager? {
        get { self[GlobalLoadingManagerKey.self] }
        set { self[GlobalLoadingManagerKey.self] = newValue }
    }
}
