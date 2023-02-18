//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public protocol PredicateExpression: NSExpressionConvertible {
    associatedtype Root
    associatedtype Value
    
    var comparisonModifier: ComparisonPredicate.Modifier { get }
}

// MARK: - Implementation

extension PredicateExpression {
    public var comparisonModifier: ComparisonPredicate.Modifier {
        .direct
    }
}

// MARK: - Conformances

extension KeyPath: PredicateExpression {
    
}

public struct AnyPredicateExpression: PredicateExpression {
    public typealias Root = Any
    public typealias Value = Any
    
    public let comparisonModifier: ComparisonPredicate.Modifier
    public let expression: NSExpressionConvertible
    
    init<E: NSExpressionConvertible & PredicateExpression>(_ expression: E) {
        self.comparisonModifier = expression.comparisonModifier
        self.expression = expression
    }
    
    public func toNSExpression(context: NSExpressionConversionContext) throws -> NSExpression {
        try expression.toNSExpression(context: context)
    }
}
