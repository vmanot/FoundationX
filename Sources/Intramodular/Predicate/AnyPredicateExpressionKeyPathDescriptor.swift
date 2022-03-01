//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

/// A descriptor for a key-path used in a predicate expression.
///
/// This descriptor contains high-level metadata such:
/// - The high level value type of the key path.
/// - The localized title of the key path.
public struct AnyPredicateExpressionKeyPathDescriptor: Codable, Hashable {
    public enum ValueType: String, Codable, Hashable {
        case string
        case integer
        case decimal
        case boolean
        case date
        case time
        case dateTime
        case array
    }
    
    public var keyPath: String
    public var localizedTitle: String?
    public var valueType: ValueType = .string
    
    public init(
        keyPath: String,
        localizedTitle: String?,
        valueType: ValueType
    ) {
        self.keyPath = keyPath
        self.localizedTitle = localizedTitle
        self.valueType = valueType
    }
}
