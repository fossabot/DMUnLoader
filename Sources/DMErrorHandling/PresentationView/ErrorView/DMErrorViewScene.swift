//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 25.01.2025.
//

import SwiftUI

///This protocol provide various loadingView that can uses for LoadingView
///check for detail: https://stackoverflow.com/a/65585090/6643923

public protocol DMErrorViewScene {
    static func getSettingsProvider() -> DMErrorViewSettings
}

internal extension DMErrorViewScene {
    static func getSettingsProvider() -> DMErrorViewSettings {
        DMErrorDefaultViewSettings()
    }
}
