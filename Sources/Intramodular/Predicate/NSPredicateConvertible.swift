//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public struct NSPredicateConversionContext {
    public let expressionConversionContext: NSExpressionConversionContext
    
    public init(
        expressionConversionContext: NSExpressionConversionContext
    ) {
        self.expressionConversionContext = expressionConversionContext
    }
}

public protocol NSPredicateConvertible {
    func toNSPredicate(context: NSPredicateConversionContext) throws -> NSPredicate
}

extension Predicate {
    public func toNSPredicate(context: NSPredicateConversionContext) throws -> NSPredicate {
        switch self {
            case let .comparison(comparison):
                switch comparison.modifier {
                    case .direct, .any, .all:
                        return NSComparisonPredicate(
                            leftExpression: try comparison.expression.toNSExpression(context: context.expressionConversionContext),
                            rightExpression: makeExpression(from: comparison.value),
                            modifier: makeComparisonModifier(from: comparison.modifier),
                            type: makeOperator(from: comparison.operator),
                            options: makeComparisonOptions(from: comparison.options)
                        )
                    case .none:
                        return NSCompoundPredicate(notPredicateWithSubpredicate: NSComparisonPredicate(
                            leftExpression: try comparison.expression.toNSExpression(context: context.expressionConversionContext),
                            rightExpression: NSExpression(forConstantValue: comparison.value),
                            modifier: makeComparisonModifier(from: comparison.modifier),
                            type: makeOperator(from: comparison.operator),
                            options: makeComparisonOptions(from: comparison.options)
                        ))
                }
            case let .boolean(value):
                return NSPredicate(value: value)
            case let .and(lhs, rhs):
                return NSCompoundPredicate(andPredicateWithSubpredicates: [
                    try lhs.toNSPredicate(context: context),
                    try rhs.toNSPredicate(context: context)
                ])
            case let .or(lhs, rhs):
                return NSCompoundPredicate(orPredicateWithSubpredicates: [
                    try lhs.toNSPredicate(context: context),
                    try rhs.toNSPredicate(context: context)
                ])
            case let .not(predicate):
                return try NSCompoundPredicate(notPredicateWithSubpredicate: predicate.toNSPredicate(context: context))
                
            case .cocoa(let predicate):
                return predicate
        }
    }
    
    private func makeExpression(from primitive: PredicateExpressionPrimitiveType) -> NSExpression {
        return NSExpression(forConstantValue: primitive.value)
    }
    
    private func makeOperator(from operator: PredicateComparison.Operator) -> NSComparisonPredicate.Operator {
        switch `operator` {
            case .beginsWith:
                return .beginsWith
            case .between:
                return .between
            case .contains:
                return .contains
            case .endsWith:
                return .endsWith
            case .equal:
                return .equalTo
            case .greaterThan:
                return .greaterThan
            case .greaterThanOrEqual:
                return .greaterThanOrEqualTo
            case .in:
                return .in
            case .lessThan:
                return .lessThan
            case .lessThanOrEqual:
                return .lessThanOrEqualTo
            case .like:
                return .like
            case .matches:
                return .matches
            case .notEqual:
                return .notEqualTo
        }
    }
    
    private func makeComparisonOptions(from options: PredicateComparison.Options) -> NSComparisonPredicate.Options {
        var comparisonOptions = NSComparisonPredicate.Options()
        
        if options.contains(.caseInsensitive) {
            comparisonOptions.formUnion(.caseInsensitive)
        }
        
        if options.contains(.diacriticInsensitive) {
            comparisonOptions.formUnion(.diacriticInsensitive)
        }
        
        if options.contains(.normalized) {
            comparisonOptions.formUnion(.normalized)
        }
        
        return comparisonOptions
    }
    
    /* private func makeSortDescriptor<T>(from sortCriterion: SortCriterion<T>) -> NSSortDescriptor {
     guard let comparator = sortCriterion.comparator else {
     return NSSortDescriptor(
     key: sortCriterion.property.stringValue,
     ascending: sortCriterion.order == .ascending
     )
     }
     
     return NSSortDescriptor(
     key: sortCriterion.property.stringValue,
     ascending: sortCriterion.order == .ascending,
     comparator: { lhs, rhs in
     guard let lhs = lhs as? T, let rhs = rhs as? T else {
     return .orderedDescending
     }
     
     return comparator(lhs, rhs)
     }
     )
     }
     */
    private func makeComparisonModifier(from modifier: PredicateExpressionComparisonModifier) -> NSComparisonPredicate.Modifier {
        switch modifier {
            case .direct:
                return .direct
            case .all:
                return .all
            case .any:
                return .any
            case .none:
                return .any
        }
    }
}


private extension PredicateExpressionPrimitiveType {
    var value: Any? {
        switch Self.predicatePrimitiveType {
            case .nil:
                return NSNull()
            default:
                return self
        }
    }
}
