//
//  AtomicTests.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 18.02.2025.
//

import XCTest
@testable import DMErrorHandling

final class AtomicTests: XCTestCase {
    
    // MARK: Initialization
    
    func testInitialization() {
        let atomic = Atomic<Int>(42)
        
        XCTAssertEqual(atomic.wrappedValue,
                       42,
                       "The initial value should match the provided value")
    }
    
    // MARK: Thread Safety
    
    func testConcurrentAccess() {
        let atomic = Atomic<Int>(0)
        let iterations = 10_000
        let queue = DispatchQueue(label: "concurrent.queue",
                                  attributes: .concurrent)
        let group = DispatchGroup()
        
        for _ in 0..<iterations {
            queue.async(group: group) {
                atomic.mutate { prop in
                    prop += 1
                }
            }
        }
        
        group.wait()
        
        XCTAssertEqual(atomic.wrappedValue,
                       iterations,
                       "The final value should match the number of increments")
    }
    
    // MARK: Mutation Behavior
    
    func testWrappedValueSetterClosureBehavior() {
        let atomic = Atomic<Int>(0)
        
        // Simulate setting a new value using the setter
        let newValue = 42
        let expectation = XCTestExpectation(description: "Value updated")
        
        DispatchQueue.global(qos: .userInitiated).async {
            atomic.wrappedValue = newValue
            expectation.fulfill()
        }
        
        wait(for: [expectation],
             timeout: 0.1)
        
        XCTAssertEqual(atomic.wrappedValue,
                       newValue,
                       "The wrappedValue should be updated to the new value")
    }
    
    func testMutate() {
        let atomic = Atomic<[Int]>([])
        
        atomic.mutate { array in
            array.append(1)
            array.append(2)
        }
        
        XCTAssertEqual(atomic.wrappedValue,
                       [1,
                        2],
                       "The mutation should modify the value correctly")
    }
    
    func testMutateWithNoChange() {
        let atomic = Atomic<Int>(42)
        
        atomic.mutate { value in
            // No changes to the value
        }
        
        XCTAssertEqual(atomic.wrappedValue,
                       42,
                       "The value should remain unchanged if no mutation occurs")
    }
    
    // MARK: Projected Value
    
    func testProjectedValue() {
        let atomic = Atomic<String>("Hello")
        
        XCTAssertTrue(atomic.projectedValue === atomic,
                      "The projected value should be the same instance as the Atomic wrapper")
    }
    
    // MARK: Call As Function
    
    func testCallAsFunction() {
        let atomic = Atomic<Double>(3.14)
        
        XCTAssertEqual(atomic(),
                       3.14,
                       "The callAsFunction method should return the wrapped value")
    }
    
    // MARK: Sendable Compliance
    
    func testSendableCompliance() {
        struct SendableStruct: Sendable {
            var value: Int
        }
        
        let atomic = Atomic<SendableStruct>(SendableStruct(value: 42))
        
        XCTAssertNoThrow({
            let _: SendableStruct = atomic.wrappedValue
        },
                         "The ValueType should comply with Sendable")
    }
}
