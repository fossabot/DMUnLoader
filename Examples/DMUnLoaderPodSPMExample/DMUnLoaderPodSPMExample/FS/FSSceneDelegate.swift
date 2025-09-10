import SwiftUI
import DMUnLoader

final class FSSceneDelegate<LM: DMLoadingManagerInteralProtocol>: UIResponder, UIWindowSceneDelegate, ObservableObject {
    var loadingManager: LM? {
        didSet {
            guard let windowScene else {
                return
            }
            setupHudWindow(in: windowScene)
        }
    }
    
#if UIKIT_APP
    var keyWindow: UIWindow?
#endif
    
    var toastWindow: UIWindow?
    weak var windowScene: UIWindowScene?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        self.windowScene = windowScene
        
#if UIKIT_APP
        if let isOwnerForLoadingManager = session.userInfo?["ownerForLoadingManager"] as? Bool,
            isOwnerForLoadingManager {
            
            self.loadingManager = AppDelegateHelper.makeLoadingManager()
        }
        
        setupMainWindow(in: windowScene)
        setupHudWindow(in: windowScene)
#endif
    }
    
    func setupHudWindow(in scene: UIWindowScene) {
        guard let windowScene = windowScene,
              let loadingManager = loadingManager else {
            return
        }
        
        let toastViewController = UIHostingController(rootView: HudSceneView(loadingManager: loadingManager))
        
        toastViewController.view.backgroundColor = .clear
        
        let toastWindow = PassThroughWindow(windowScene: windowScene)
        toastWindow.rootViewController = toastViewController
        toastWindow.isHidden = false
        self.toastWindow = toastWindow
    }
    
#if UIKIT_APP
    func setupMainWindow(in scene: UIWindowScene) {
        guard let windowScene = windowScene,
              let loadingManager = loadingManager else {
            return
        }
        
        let window = UIWindow(windowScene: scene)
        let appDelegateHelper = AppDelegateHelper()
        
        
        let rootVC = appDelegateHelper.makeUIKitRootViewHierarhy(loadingManager: loadingManager)
        
        window.rootViewController = rootVC
        self.keyWindow = window
        window.makeKeyAndVisible()
    }
#endif
}
