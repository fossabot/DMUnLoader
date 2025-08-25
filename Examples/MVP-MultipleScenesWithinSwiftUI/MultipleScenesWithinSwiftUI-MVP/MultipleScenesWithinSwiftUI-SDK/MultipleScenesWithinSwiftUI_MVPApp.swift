//
//  MultipleScenesWithinSwiftUI-MVP
//
//  Created by Mykola Dementiev
//

import SwiftUI
import MPSwiftUI_SDK

@main
struct MultipleScenesWithinSwiftUI_MVPApp: App {
    @StateObject var hudState = HudState()
    @UIApplicationDelegateAdaptor var delegate: MVPAppDelegate
    
    var body: some Scene {
        WindowGroup {
            AppMainSceneView(hudState: hudState)
        }
    }
}
