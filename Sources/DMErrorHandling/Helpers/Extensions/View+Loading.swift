//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI

public extension View {
    func autoLoading(_ loadingManager: LoadingManager) -> some View {
        self
            .environmentObject(loadingManager)
            .modifier(
                LoadingModifier(loadingManager: loadingManager)
            )
    }
}
