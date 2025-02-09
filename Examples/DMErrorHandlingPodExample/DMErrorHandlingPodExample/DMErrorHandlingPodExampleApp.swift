//
//  DMErrorHandlingPodExampleApp.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 22.01.2025.
//


import UIKit
import SwiftUI
import DMErrorHandling

#if UIKIT_APP

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppDelegateHelper.makeAppDescriprtion()
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appDelegateHelper = AppDelegateHelper()
        
        let rootVC = appDelegateHelper.makeUIKitRootViewHierarhy()
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
}

#elseif SWIFTUI_APP

@main
struct DMErrorHandlingPodExampleApp: App {
    
    init () {
        AppDelegateHelper.makeAppDescriprtion()
    }
    
    var body: some Scene {
        WindowGroup {
            AppDelegateHelper.RootLoadingView()
        }
    }
}
#endif


internal struct AppDelegateHelper {

    static private(set) internal var appDescriprtion: String = ""
    
    static func makeAppDescriprtion() {
#if UIKIT_APP
        appDescriprtion += "\nFramework: `UIKit`"
#elseif SWIFTUI_APP
        appDescriprtion += "\nFramework: `SwiftUI`"
#endif
        
        appDescriprtion += "\nUses dependency manager: `\(getDependencyManager() ?? "???")`"
    }
    
    static func addAppDescriprtion(_ newString: String) {
        appDescriprtion += newString
    }
    
    func makeUIKitRootViewHierarhy() -> DMRootViewControllerUIKit<UIView> {
        let rootVC = DMRootViewControllerUIKit()
        
        let tabViewController = MainTabViewControllerUIKit(manager: rootVC.getLoadingManager())
        
        // Add MainTabViewControllerUIKit as a child controller
        tabViewController.willMove(toParent: rootVC)
        rootVC.addChild(tabViewController)
        tabViewController.view.frame = rootVC.view.bounds
        tabViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootVC.view.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: rootVC)
        
        return rootVC
    }
    
    struct RootLoadingView: View {
        var body: some View {
            DMRootLoadingView { _ in
                MainTabView()
            }
        }
    }
    
    static func getDependencyManager() -> String? {
        // Get the path to the .dependency_manager file
        guard let filePath = Bundle.main.path(forResource: ".dependency_manager", ofType: nil) else {
            print("Error: .dependency_manager file not found.")
            return nil
        }
        
        // Read the contents of the file
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            
            // Parse the DEPENDENCY_MANAGER value
            if let range = fileContents.range(of: "DEPENDENCY_MANAGER=", options: .caseInsensitive) {
                let startIndex = fileContents.index(range.upperBound, offsetBy: 0)
                let remainingString = fileContents[startIndex...]
                
                // Trim whitespace and newlines to extract the value
                let value = remainingString.split(separator: "\n").first?.trimmingCharacters(in: .whitespacesAndNewlines)
                return value
            } else {
                print("Error: DEPENDENCY_MANAGER key not found in .dependency_manager file.")
                return nil
            }
        } catch {
            print("Error reading .dependency_manager file: \(error)")
            return nil
        }
    }
    
//    static func getDependencyManager() -> String? {
//        let fileManager = FileManager.default
//
//        // Get the path to the project root directory
//        guard let resourcePath = Bundle.main.resourcePath,
//              let resourceURL = URL(string: resourcePath),
//              let projectRootURL = resourceURL.deletingLastPathComponent().absoluteString.removingPercentEncoding else {
//            print("Failed to determine the project root directory.")
//            return nil
//        }
//
//        let projectRoot = projectRootURL.replacingOccurrences(of: "file://", with: "") // Remove "file://" prefix
//
//        // Construct the full path to the .dependency_manager file
//        let dependencyFilePath = "\(projectRoot)/.dependency_manager"
//
//        // Check if the file exists
//        if !fileManager.fileExists(atPath: dependencyFilePath) {
//            print("File not found at path: \(dependencyFilePath)")
//            return nil
//        }
//
//        do {
//            // Read the file contents
//            let fileContents = try String(contentsOfFile: dependencyFilePath, encoding: .utf8)
//
//            // Extract the value of DEPENDENCY_MANAGER
//            if let range = fileContents.range(of: "DEPENDENCY_MANAGER=", options: .caseInsensitive) {
//                let startIndex = fileContents.index(range.upperBound, offsetBy: 0)
//                let remainingString = fileContents[startIndex...]
//
//                // Trim whitespace and newlines to extract the value
//                let value = remainingString.split(separator: "\n").first?.trimmingCharacters(in: .whitespacesAndNewlines)
//                return value
//            } else {
//                print("DEPENDENCY_MANAGER key not found in file.")
//                return nil
//            }
//        } catch {
//            print("Error reading .dependency_manager file: \(error)")
//            return nil
//        }
//    }
}
