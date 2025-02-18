//
//  SchemaArgumentsTests.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 18.02.2025.
//

import XCTest
@testable import DMErrorHandling

final class SchemaArgumentsTests: XCTestCase {
    
    override func tearDown() {
        var schemaArguments = SchemaArguments()
        schemaArguments.resetSettingToDefault()
        
        super.tearDown()
    }
    
    func testIsInspectionEnabledWhenArgumentIsPresent() {
        // Arrange
        let mockProcessInfoProvider = MockProcessInfoProvider(arguments: ["--enable-inspection"])
        var schemaArguments = SchemaArguments()
        schemaArguments.currentProcessInfoProvider = mockProcessInfoProvider
        
        // Act & Assert
        XCTAssertTrue(schemaArguments.isInspectionEnabled,
                      "isInspectionEnabled should be true when '--enable-inspection' is present")
    }
    
    func testIsInspectionEnabledWhenArgumentIsMissing() {
        // Arrange
        let mockProcessInfoProvider = MockProcessInfoProvider(arguments: [])
        var schemaArguments = SchemaArguments()
        schemaArguments.currentProcessInfoProvider = mockProcessInfoProvider
        
        // Act & Assert
        XCTAssertFalse(schemaArguments.isInspectionEnabled,
                       "isInspectionEnabled should be false when '--enable-inspection' is missing")
    }
    
    func testIsInspectionEnabledWithCustomArguments() {
        // Arrange
        let mockProcessInfoProvider = MockProcessInfoProvider(arguments: ["--other-argument",
                                                                          "--enable-inspection",
                                                                          "--another-argument"])
        var schemaArguments = SchemaArguments()
        schemaArguments.currentProcessInfoProvider = mockProcessInfoProvider
        
        // Act & Assert
        XCTAssertTrue(schemaArguments.isInspectionEnabled,
                      "isInspectionEnabled should be true when '--enable-inspection' is among other arguments")
    }
}
