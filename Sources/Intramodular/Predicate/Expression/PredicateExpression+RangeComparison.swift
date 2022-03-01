//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

extension PredicateExpression where Value: Comparable & PredicateExpressionPrimitive {
    public func between(_ range: ClosedRange<Value>) -> Predicate<Root> {
        .comparison(.init(self, .between, [range.lowerBound, range.upperBound]))
    }
}

public func ~= <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitive> (
    lhs: E,
    rhs: ClosedRange<T>
) -> Predicate<E.Root> where E.Value == T {
    lhs.between(rhs)
}