//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public protocol PredicateExpression: NSExpressionConvertible {
    associatedtype Root
    associatedtype Value
    
    var comparisonModifier: PredicateExpressionComparisonModifier { get }
}

public enum PredicateExpressionComparisonModifier {
    case direct
    case all
    case any
    case none
}

// MARK: - Implementation -

extension PredicateExpression {
    public var comparisonModifier: PredicateExpressionComparisonModifier { .direct }
}

// MARK: - Conformances -

extension KeyPath: PredicateExpression {
    
}

struct AnyPredicateExpression: NSExpressionConvertible {
    let comparisonModifier: PredicateExpressionComparisonModifier
    
    private let expression: NSExpressionConvertible
    
    init<E: NSExpressionConvertible & PredicateExpression>(_ expression: E) {
        self.comparisonModifier = expression.comparisonModifier
        self.expression = expression
    }
    
    public func toNSExpression(context: NSExpressionConversionContext) throws -> NSExpression {
        try expression.toNSExpression(context: context)
    }
}
