import SwiftUI

public final class DMAppDelegate<LM: DMLoadingManagerProtocol>: NSObject, UIApplicationDelegate {
    public func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = DMSceneDelegateBase<LM>.self
        return sceneConfig
    }
}
