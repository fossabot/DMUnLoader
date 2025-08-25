//
//  MultipleScenesWithinSwiftUI-MVP
//
//  Created by Mykola Dementiev
//

import SwiftUI
import MPSwiftUI_SDK

@main
struct MultipleScenesWithinSwiftUI_MVPApp: App {
    var body: some Scene {
        MultipleScenesWithinSwiftUI_SDK_Scene { scene in
            WindowGroup {
                ContentView()
//                AppMainSceneView(hudState: scene.hudState)
            }
        }
    }
}
