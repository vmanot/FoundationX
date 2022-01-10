//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

/// A type-safe set of conditions used to filter a list of objects of type `Root`.
public indirect enum Predicate<Root>: NSPredicateConvertible {
    case comparison(PredicateComparison)
    case boolean(Bool)
    case and(Predicate<Root>, Predicate<Root>)
    case or(Predicate<Root>, Predicate<Root>)
    case not(Predicate<Root>)
    
    case cocoa(NSPredicate)
}

public struct AnyPredicate: NSPredicateConvertible {
    private let base: NSPredicateConvertible
    
    public init(_ predicate: NSPredicate) {
        self.base = predicate
    }
    
    public init<Root>(_ predicate: Predicate<Root>) {
        self.base = predicate
    }
    
    public func toNSPredicate(context: NSPredicateConversionContext) throws -> NSPredicate {
        try base.toNSPredicate(context: context)
    }
}

public enum ComparisonPredicationExpressionTransform<
    Input: PredicateExpression,
    Output
>: PredicateExpression where Input.Value: AnyArrayOrSet {
    public typealias Root = Input.Root
    public typealias Value = Output
    
    case average(Input)
    case count(Input)
    case sum(Input)
    case min(Input)
    case max(Input)
    case mode(Input)
    case size(Input)
}

public enum ArrayIndexPredicateExpression<Array: PredicateExpression>: PredicateExpression where Array.Value: AnyArray {
    public typealias Root = Array.Root
    public typealias Value = Array.Value.ArrayElement
    
    case index(Array, Int)
    case first(Array)
    case last(Array)
}

public struct QueryPredicateExpression<Root, Subject: AnyArrayOrSet>: PredicateExpression {
    public typealias Value = Subject
    
    let key: AnyKeyPath
    let predicate: Predicate<Subject.Element>
}

// MARK: - Compound Predicates

public func && <T> (lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    .and(lhs, rhs)
}

public func || <T> (lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    .or(lhs, rhs)
}

public prefix func ! <T> (predicate: Predicate<T>) -> Predicate<T> {
    .not(predicate)
}


// MARK: - Aggregate Operations

extension PredicateExpression where Value: AnyArrayOrSet {
    public var all: ArrayElementKeyPathPredicateExpression<Self, Value.Element> {
        all(\Value.Element.self)
    }
    
    public var any: ArrayElementKeyPathPredicateExpression<Self, Value.Element> {
        any(\Value.Element.self)
    }
    
    public var none: ArrayElementKeyPathPredicateExpression<Self, Value.Element> {
        none(\Value.Element.self)
    }
    
    public func all<T>(_ keyPath: KeyPath<Value.Element, T>) -> ArrayElementKeyPathPredicateExpression<Self, T> {
        .init(.all, self, keyPath)
    }
    
    public func any<T>(_ keyPath: KeyPath<Value.Element, T>) -> ArrayElementKeyPathPredicateExpression<Self, T> {
        .init(.any, self, keyPath)
    }
    
    public func none<T>(_ keyPath: KeyPath<Value.Element, T>) -> ArrayElementKeyPathPredicateExpression<Self, T> {
        .init(.none, self, keyPath)
    }
}

extension PredicateExpression where Value: PredicateExpressionPrimitiveType {
    public func `in`(_ list: Value...) -> Predicate<Root> {
        .comparison(.init(self, .in, list))
    }
}

extension PredicateExpression where Value == String {
    public func `in`(_ list: [Value], _ options: PredicateComparison.Options = .caseInsensitive) -> Predicate<Root> {
        .comparison(.init(self, .in, list, options))
    }
}


// MARK: - Sub-predicates

/// Creates a query to filter the collection of objects represented by the specified key-path.
///
/// - Parameters:
///   - keyPath: The key-path representing the collection to filter. The value of this key-path must be a valid
///     collection (an array or a set).
///   - predicate: The predicate to use to filter the collection.
///
/// - Returns: A query returning an array of objects matching the specified predicate. The returned query
///   can be composed in more complex predicates.
///
/// ###### Example
///
///       (\Account.name).contains("Account") && all(\.profiles, where: (\Profile.name).contains("Doe")).size == 2)
///
public func all<T, U: AnyArrayOrSet>(_ keyPath: KeyPath<T, U>, where predicate: Predicate<U.Element>) -> QueryPredicateExpression<T, U> {
    .init(key: keyPath, predicate: predicate)
}

// MARK: - Boolean predicates

extension Predicate: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}


// MARK: - Supporting Protocols

// MARK: - AnyArrayOrSet

public protocol AnyArrayOrSet {
    associatedtype Element
}

extension Array: AnyArrayOrSet {
}

extension Set: AnyArrayOrSet {
}

extension NSSet: AnyArrayOrSet {
}

extension Optional: AnyArrayOrSet where Wrapped: AnyArrayOrSet {
    public typealias Element = Wrapped.Element
}

// MARK: - AnyArray

public protocol AnyArray {
    associatedtype ArrayElement
}

extension Array: AnyArray {
    public typealias ArrayElement = Element
}

extension Optional: AnyArray where Wrapped: AnyArray {
    public typealias ArrayElement = Wrapped.ArrayElement
}

// MARK: - PrimitiveCollection

public protocol PrimitiveCollection {
    associatedtype PrimitiveElement: PredicateExpressionPrimitiveType
}

extension Array: PrimitiveCollection where Element: PredicateExpressionPrimitiveType {
    public typealias PrimitiveElement = Element
}

extension Set: PrimitiveCollection where Element: PredicateExpressionPrimitiveType {
    public typealias PrimitiveElement = Element
}

extension Optional: PrimitiveCollection where Wrapped: PrimitiveCollection {
    public typealias PrimitiveElement = Wrapped.PrimitiveElement
}

// MARK: - AdditiveCollection

public protocol AdditiveCollection {
    associatedtype AdditiveElement: AdditiveArithmetic & PredicateExpressionPrimitiveType
}

extension Array: AdditiveCollection where Element: AdditiveArithmetic & PredicateExpressionPrimitiveType {
    public typealias AdditiveElement = Element
}

extension Optional: AdditiveCollection where Wrapped: PrimitiveCollection & AdditiveCollection {
    public typealias AdditiveElement = Wrapped.AdditiveElement
}

// MARK: - ComparableCollection

public protocol ComparableCollection {
    associatedtype ComparableElement: Comparable & PredicateExpressionPrimitiveType
}

extension Array: ComparableCollection where Element: Comparable & PredicateExpressionPrimitiveType {
    public typealias ComparableElement = Element
}

extension Optional: ComparableCollection where Wrapped: ComparableCollection {
    public typealias ComparableElement = Wrapped.ComparableElement
}
