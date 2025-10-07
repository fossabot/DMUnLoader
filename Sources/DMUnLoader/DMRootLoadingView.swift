//  Created by Mykola Dementiev
//

import SwiftUI

public struct DMRootLoadingView<
    LM: DMLoadingManagerProtocol,
    Content: View
>: View {
    @EnvironmentObject private var sceneDelegate: FSSceneDelegateSwiftUI<LM>
    @StateObject private var loadingManager = LM()
    
    private let content: (LM) -> Content
    
    public init(@ViewBuilder content: @escaping (LM) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(loadingManager)
            .onAppear {
                sceneDelegate.loadingManager = loadingManager
            }
    }
}
