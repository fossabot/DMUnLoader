//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import UIKit

// TODO: need to check acess modifiers (mark it as internal)!

public class PassThroughWindow: UIWindow {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == hitView ? nil : hitView
    }
}
