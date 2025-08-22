//
//  DMUnLoader
//
//  Created by Mykola Dementiev
//

import DMUnLoader
import Foundation

enum ViewSettingsHelper {
    static func makeLoadingCustomSettings() -> DMLoadingDefaultViewSettings {
        DMLoadingDefaultViewSettings(
            loadingTextProperties: LoadingTextProperties(
                text: "Processing...",
                alignment: .leading,
                foregroundColor: .orange,
                font: .title3,
                lineLimit: 2
            ),
            progressIndicatorProperties: ProgressIndicatorProperties(
                tintColor: .green
            ),
            frameGeometrySize: CGSize(width: 300, height: 300)
        )
    }
}
