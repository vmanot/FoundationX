//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

enum ArrayElementKeyPathType: Equatable {
    case index(Int)
    case first
    case last
    case all
    case any
    case none
}

public struct ArrayElementKeyPathPredicateExpression<Array, Value>: PredicateExpression where Array: PredicateExpression, Array.Value: AnyArrayOrSet {
    public typealias Root = Array.Root
    public typealias Element = Array.Value.Element
    
    let type: ArrayElementKeyPathType
    let array: Array
    let elementKeyPath: AnyKeyPath
    
    public var comparisonModifier: PredicateExpressionComparisonModifier {
        switch type {
            case .first, .last, .index:
                return .direct
            case .all:
                return .all
            case .any:
                return .any
            case .none:
                return .none
        }
    }
    
    init(
        _ type: ArrayElementKeyPathType,
        _ array: Array,
        _ elementKeyPath: AnyKeyPath
    ) {
        self.type = type
        self.array = array
        self.elementKeyPath = elementKeyPath
    }
}

extension ArrayElementKeyPathPredicateExpression: NSExpressionConvertible where Array: NSExpressionConvertible {
    public func toNSExpression(context: NSExpressionConversionContext) throws -> NSExpression {
        func value() throws -> String {
            switch type {
                case .any, .all, .none:
                    return try "\(array.toNSExpression(context: context)).\(context.convertKeyPathToString(elementKeyPath))"
                case .first:
                    return try "\(array.toNSExpression(context: context))[FIRST].\(context.convertKeyPathToString(elementKeyPath))"
                case .last:
                    return try "\(array.toNSExpression(context: context))[LAST].\(context.convertKeyPathToString(elementKeyPath))"
                case let .index(index):
                    return try "\(array.toNSExpression(context: context))[\(index)].\(context.convertKeyPathToString(elementKeyPath))"
            }
        }
        
        return try NSExpression(format: value().replacingOccurrences(of: ".self", with: ""))
    }
}
