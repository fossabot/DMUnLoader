//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import ViewInspector

@preconcurrency import Combine
internal final class Inspection<V>: @unchecked Sendable {

    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}

// need to be in test target!

extension Inspection: InspectionEmissary { }
