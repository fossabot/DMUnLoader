//
//  DMLocalUIKitLoadingView.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 03.02.2025.
//

import SwiftUI
import UIKit

open class DMLocalLoadingViewUIKit<View: UIView, Provider: DMLoadingViewProvider>: UIView {
    private typealias HostingControllerType = DMLocalLoadingView<DMUIKitWrappedView<View>, Provider>
    private let hostingController: UIHostingController<HostingControllerType>
    
    public weak var loadingManager: DMLoadingManager?
    
    public init(provider: Provider, innerView: View) {
        let swiftUIView = Self.makeSwiftUIView(provider: provider, view: innerView)
        
        hostingController = UIHostingController(rootView: swiftUIView)
        super.init(frame: .zero)
       

        self.loadingManager = swiftUIView.getLoadingManager()
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Content updates (if necessary)
    public func updateContent(provider: Provider, view: View) {
        hostingController.rootView = Self.makeSwiftUIView(provider: provider, view: view)
    }
    */
    
    private func setupUI() {
        guard let view = hostingController.view else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private static func makeSwiftUIView(provider: Provider, view: View) -> HostingControllerType {
        let newView = DMLocalLoadingView(provider: provider) {
            DMUIKitWrappedView(uiView: view)
        }
        
        return newView
    }
}
