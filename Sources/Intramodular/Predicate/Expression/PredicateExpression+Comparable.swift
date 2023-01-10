//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public func < <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitive> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .lessThan, rhs))
}

public func <= <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitive> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .lessThanOrEqual, rhs))
}

public func == <E: PredicateExpression, T: Equatable & PredicateExpressionPrimitive> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .equal, rhs))
}

public func == <E: PredicateExpression, T: PredicateExpressionPrimitiveConvertible> (lhs: E, rhs: T) -> Predicate<E.Root> {
    .comparison(.init(lhs, .equal, rhs.toPredicateExpressionPrimitive()))
}

public func == <E: PredicateExpression, T: RawRepresentable> (lhs: E, rhs: T) -> Predicate<E.Root> where T.RawValue: Equatable & PredicateExpressionPrimitive {
    .comparison(.init(lhs, .equal, rhs.rawValue))
}

@_disfavoredOverload
public func == <E: PredicateExpression> (lhs: E, rhs: NilPredicateExpressionValue) -> Predicate<E.Root> where E.Value: OptionalProtocol {
    .comparison(.init(lhs, .equal, rhs))
}

public func != <E: PredicateExpression, T: Equatable & PredicateExpressionPrimitive> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .notEqual, rhs))
}

public func >= <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitive> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .greaterThanOrEqual, rhs))
}

public func > <E: PredicateExpression, T: Comparable & PredicateExpressionPrimitive> (lhs: E, rhs: T) -> Predicate<E.Root> where E.Value == T {
    .comparison(.init(lhs, .greaterThan, rhs))
}
