//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import Foundation
@testable import DMUnLoader

struct StubDMLoadingManagerSettings: DMLoadingManagerSettings {
    let autoHideDelay: Duration
    
    init(autoHideDelay: Duration = .seconds(0.5)) {
        self.autoHideDelay = autoHideDelay
    }
}
