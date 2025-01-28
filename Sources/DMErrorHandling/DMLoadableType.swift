//
//  DMLoadableType.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 16.01.2025.
//

import SwiftUI

public enum DMLoadableType: Hashable, RawRepresentable {
    public typealias RawValue = String
    
    case loading
    case failure(error: Error, onRetry: (() -> Void)? = nil)
    case success(Any) //TODO: need to wrap into some protocol to omit casting from Any
    case none
    
    public var rawValue: RawValue {
        let rawValueForReturn: RawValue
        switch self {
        case .loading:
            rawValueForReturn = "Loading"
        case .failure(let error, _):
            rawValueForReturn = "Error: \(error)"
        case .success(let message):
            rawValueForReturn = "Success: \(message)"
        case .none:
            rawValueForReturn = "None"
        }
        
        return rawValueForReturn
    }
    
    public init?(rawValue: RawValue) {
        nil
    }
    
    public static func == (lhs: DMLoadableType,
                           rhs: DMLoadableType) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
