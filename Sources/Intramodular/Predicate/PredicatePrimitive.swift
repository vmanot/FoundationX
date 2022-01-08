//
// Copyright (c) Vatsal Manot
//

import Foundation

public protocol PredicateExpressionPrimitiveType {
    static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { get }
}

public indirect enum PredicateExpressionPrimitiveTypeType: Equatable {
    case bool
    case int
    case int8
    case int16
    case int32
    case int64
    case uint
    case uint8
    case uint16
    case uint32
    case uint64
    case double
    case float
    case string
    case date
    case url
    case uuid
    case data
    case wrapped(PredicateExpressionPrimitiveTypeType)
    case array(PredicateExpressionPrimitiveTypeType)
    case `nil`
}

extension Bool: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .bool }
}

extension Int: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .int }
}

extension Int8: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .int8 }
}

extension Int16: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .int16 }
}

extension Int32: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .int32 }
}

extension Int64: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .int64 }
}

extension UInt: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .uint }
}

extension UInt8: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .uint8 }
}

extension UInt16: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .uint16 }
}

extension UInt32: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .uint32 }
}

extension UInt64: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .uint64 }
}

extension Double: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .double }
}

extension Float: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .float }
}

extension String: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .string }
}

extension Date: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .date }
}

extension PredicateExpressionPrimitiveType where Self: RawRepresentable, RawValue: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { RawValue.predicatePrimitiveType }
}

extension Array: PredicateExpressionPrimitiveType where Element: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .array(Element.predicatePrimitiveType) }
}

extension URL: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .url }
}

extension UUID: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .uuid }
}

extension Data: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .data }
}

extension Optional: PredicateExpressionPrimitiveType where Wrapped: PredicateExpressionPrimitiveType {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { Wrapped.predicatePrimitiveType }
}

public struct Nil: PredicateExpressionPrimitiveType, ExpressibleByNilLiteral {
    public static var predicatePrimitiveType: PredicateExpressionPrimitiveTypeType { .nil }
    
    public init(nilLiteral: ()) {
    }
}

// MARK: - Optional

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.some(lhs), .some(rhs)):
                return lhs < rhs
            default:
                return false
        }
    }
}
