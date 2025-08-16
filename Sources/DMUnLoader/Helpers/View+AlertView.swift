//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import SwiftUI

extension View {
    @inlinable nonisolated func addModificationForAlerView() -> some View {
        self
        .padding(30)
        .background(Color.gray.opacity(0.8))
        .cornerRadius(10)
    }
}
