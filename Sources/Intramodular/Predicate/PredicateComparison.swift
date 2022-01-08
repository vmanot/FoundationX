//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public struct PredicateComparison {
    enum Operator {
        case lessThan
        case lessThanOrEqual
        case equal
        case notEqual
        case greaterThanOrEqual
        case greaterThan
        case between
        case beginsWith
        case contains
        case endsWith
        case like
        case matches
        case `in`
    }

    public struct Options: OptionSet {
        public let rawValue: Int
        
        public static let caseInsensitive = Self(rawValue: 1 << 0)
        public static let diacriticInsensitive = Self(rawValue: 1 << 1)
        public static let normalized = Self(rawValue: 1 << 2)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    let expression: AnyPredicateExpression
    let `operator`: Operator
    let options: PredicateComparison.Options
    let value: PredicateExpressionPrimitiveType
    
    var modifier: PredicateExpressionComparisonModifier {
        expression.comparisonModifier
    }
}

extension PredicateComparison {
    init<E: PredicateExpression>(
        _ expression: E,
        _ `operator`: PredicateComparison.Operator,
        _ value: PredicateExpressionPrimitiveType,
        _ options: PredicateComparison.Options = .caseInsensitive
    ) {
        self.expression = AnyPredicateExpression(expression)
        self.operator = `operator`
        self.value = value
        self.options = options
    }
}
