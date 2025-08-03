//
//  EssentialFeedTests
//
//  Created by Mykola Dementiev
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks<T: AnyObject & Sendable>(_ ins: T,
                                                      file: StaticString = #filePath,
                                                      line: UInt = #line) {
        addTeardownBlock { [weak ins] in
            XCTAssertNil(ins,
                         "Instance should be dealocated. Potentially it's memory leak.",
                         file: file,
                         line: line)
        }
    }
}
