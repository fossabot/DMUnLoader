//
//  RootViewController.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 03.02.2025.
//

import UIKit
import SwiftUI

public final class DMRootViewController: UIViewController {
    private var hostingController: UIHostingController<DMRootLoadingView<DMUIKitWrappedView<UIView>>>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Створення нової UIKit-вʼю
        let newViewToApply = UIView()
        newViewToApply.backgroundColor = .orange // FOR TEST ONLY //TODO: remove test enviroments!
        
        // Створення SwiftUI-вʼю
        let rootView = DMRootLoadingView {
            // Використання UIKit-вʼю як Контенту для Root SwiftUI-вʼю
            DMUIKitWrappedView(uiView: newViewToApply)
        }
        
        // Створення UIHostingController
        let hostingController = UIHostingController(rootView: rootView)
        self.hostingController = hostingController
        
        // Додаємо як дочірній контролер
        hostingController.willMove(toParent: self)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
