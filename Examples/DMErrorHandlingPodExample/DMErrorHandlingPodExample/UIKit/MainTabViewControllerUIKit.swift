//
//  MainTabViewControllerUIKit.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 03.02.2025.
//

import UIKit
import DMErrorHandling

class MainTabViewControllerUIKit: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // Перша вкладка - Default
        let defaultVC = createNavController(
            viewController: DefaultSettingsViewController(),
            title: "Default",
            imageName: "gearshape"
        )
        
        // Друга вкладка - Custom
        let customVC = createNavController(
            viewController: CustomSettingsViewController(),
            title: "Custom",
            imageName: "pencil"
        )
        
        viewControllers = [defaultVC, customVC]
    }
    
    private func createNavController(
        viewController: UIViewController,
        title: String,
        imageName: String) -> UINavigationController {
            
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        return navController
    }
}

// MARK: - View Controllers для вкладок
class DefaultSettingsViewController: UIViewController {
    override func loadView() {
        super.loadView()
        view = ContentViewDefaultSettingsUIKit(provider: DefaultDMLoadingViewProvider(),
                                               innerView: LoadingContentViewUIKit())
        view.setNeedsUpdateConstraints()
    }
}

class CustomSettingsViewController: UIViewController {
    override func loadView() {
        super.loadView()
        view = ContentViewCustomSettingsUIKit(provider: CustomDMLoadingViewProvider(),
                                              innerView: LoadingContentViewUIKit())
        view.setNeedsUpdateConstraints()
    }
}
