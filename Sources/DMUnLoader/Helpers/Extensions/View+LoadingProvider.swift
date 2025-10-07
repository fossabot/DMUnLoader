//  Created by Mykola Dementiev
//

import SwiftUI

public extension View {
    func setLoadingViewProvider(
        _ provider: some DMLoadingViewProviderProtocol
    ) -> some View {
        self.environment(\.loadingViewProvider, provider)
    }
}
