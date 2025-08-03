//
//  EssentialFeedTests
//
//  Created by Mykola Dementiev
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "TestDomain", code: 404, userInfo: nil)
}

func anyData() -> Data {
    Data("any data".utf8)
}
