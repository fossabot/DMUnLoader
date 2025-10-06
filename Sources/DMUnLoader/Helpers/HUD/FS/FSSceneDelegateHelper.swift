//  Created by Mykola Dementiev
//

import UIKit

public protocol FSSceneDelegateHelper {
    @MainActor
    static func makeLoadingManager<LM>() -> LM where LM: DMLoadingManagerInteralProtocol
    
    static func makeUIKitRootViewHierarhy<LM: DMLoadingManagerInteralProtocol>(loadingManager: LM) -> UIViewController
}

extension FSSceneDelegateHelper {
    @MainActor
    public static func makeLoadingManager<LM: DMLoadingManagerInteralProtocol>() -> LM {
        LM()
    }
    
    static func makeUIKitRootViewHierarhy<LM: DMLoadingManagerInteralProtocol>(loadingManager: LM) -> UIViewController {
        
        UIViewController(nibName: nil, bundle: nil)
    }
}
