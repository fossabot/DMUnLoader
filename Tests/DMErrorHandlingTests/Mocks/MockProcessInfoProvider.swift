//
//  MockProcessInfoProvider.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 18.02.2025.
//

@testable import DMErrorHandling

internal struct MockProcessInfoProvider: ProcessInfoProvider {
    var arguments: [String]
}
