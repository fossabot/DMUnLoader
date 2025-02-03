//
//  DMUIKitWrappedView.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 03.02.2025.
//

import SwiftUI
import UIKit

public struct DMUIKitWrappedView<View: UIView>: UIViewRepresentable {
    public let uiView: View
    
    public func makeUIView(context: Context) -> UIView {
//        let uiView = View()
//        uiView.backgroundColor = .systemBlue // Просто фон для прикладу
        return uiView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // Тут можна оновлювати `UIView`, якщо потрібно
    }
}
