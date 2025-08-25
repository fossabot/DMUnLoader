//
//  MultipleScenesWithinSwiftUI-MVP
//
//  Created by Mykola Dementiev
//

import Combine

public final class HudState: ObservableObject {
    @Published var isPresented: Bool
    
    internal init(isPresented: Bool = false) {
        self.isPresented = isPresented
    }
    
    public func show() {
        isPresented = true
    }
}
