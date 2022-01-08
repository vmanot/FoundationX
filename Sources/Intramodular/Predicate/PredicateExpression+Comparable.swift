//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public func < <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitiveType> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .lessThan, rhs))
}

public func <= <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitiveType> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .lessThanOrEqual, rhs))
}

public func == <E: PredicateExpression, T: Equatable & PredicateExpressionPrimitiveType> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .equal, rhs))
}

@_disfavoredOverload
public func == <E: PredicateExpression> (lhs: E, rhs: Nil) -> Predicate<E.Root> where E.Value: OptionalProtocol {
    .comparison(.init(lhs, .equal, rhs))
}

public func != <E: PredicateExpression, T: Equatable & PredicateExpressionPrimitiveType> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .notEqual, rhs))
}

public func >= <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitiveType> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .greaterThanOrEqual, rhs))
}

public func > <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitiveType> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .greaterThan, rhs))
}

