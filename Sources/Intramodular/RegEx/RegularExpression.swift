//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public var RegEx: RegularExpression {
    return .init()
}

public struct RegularExpression: Initiable {
    public typealias Options = NSRegularExpression.Options
    
    public var pattern: String
    public var options: Options
    
    public var isValid: Bool {
        return (try? NSRegularExpression(pattern: pattern, options: options)).isNotNil
    }
    
    public init(pattern: String = "", options: Options = []) {
        self.pattern = pattern
        self.options = options
    }
    
    public init() {
        self.init(pattern: .init())
    }
    
    func modifyPattern(_ modify: (String) -> String) -> Self {
        .init(pattern: modify(pattern), options: options)
    }
}

// MARK: - Extensions -

extension RegularExpression {
    public func matchAndCaptureRanges(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [(Range<String.Index>, [Range<String.Index>?])] {
        var result = [(Range<String.Index>, [Range<String.Index>?])]()
        
        let matches = (self as NSRegularExpression).matches(
            in: string,
            options: options,
            range: NSRange(string.bounds, in: string)
        )
        
        for match in matches {
            let matchedString = string[match.range]
            let captured = (1..<match.numberOfRanges).map(match.range(at:)).map({ Range.init($0, in: string) })
            
            result.append((matchedString.bounds, captured))
        }
        
        return result
    }
    
    public func matchAndCaptureSubstrings(in string: String) -> [(Substring, [Substring])] {
        var result = [(Substring, [Substring])]()
        
        let matches = (self as NSRegularExpression).matches(in: string, options: .reportCompletion, range: NSRange(string.bounds, in: string))
        
        for match in matches {
            let matchedString = string[match.range]
            let captured = (1..<match.numberOfRanges).map(match.range(at:)).map({ string[$0] })
            
            result.append((matchedString, captured))
        }
        
        return result
    }
}

extension RegularExpression {
    public func matchRanges(in string: String) -> [Range<String.Index>] {
        (self as NSRegularExpression)
            .matches(in: string, range: string.nsRangeBounds)
            .map({ Range($0.range, in: string)! })
    }
}

extension RegularExpression {
    public func replace(in string: String, withTemplate template: String) -> String {
        (self as NSRegularExpression).stringByReplacingMatches(in: string, options: [], range: .init(0..<string.count), withTemplate: template)
    }
    
    public func replace(in string: String, with other: String) -> String {
        replace(in: string, withTemplate: NSRegularExpression.escapedTemplate(for: other))
    }
}

// MARK: - Protocol Conformances -

extension RegularExpression: AdditionOperatable {
    @inlinable
    public static func + (lhs: RegularExpression, rhs: RegularExpression) -> RegularExpression {
        return .init(pattern: lhs.pattern.appending(rhs.pattern), options: lhs.options.union(rhs.options))
    }
    
    public func append(_ expression: Self) -> Self {
        self + expression
    }
    
    @inlinable
    public static func += (lhs: inout RegularExpression, rhs: RegularExpression) {
        lhs = lhs + rhs
    }
    
    @inlinable
    public static func + (lhs: RegularExpression, rhs: String) -> RegularExpression {
        lhs + .init(rhs)
    }
    
    @inlinable
    public static func += (lhs: inout RegularExpression, rhs: String) {
        lhs = lhs + rhs
    }
    
    @inlinable
    public static func + (lhs: String, rhs: RegularExpression) -> RegularExpression {
        .init(lhs) + rhs
    }
}

extension RegularExpression: CustomDebugStringConvertible {
    public var debugDescription: String {
        return pattern.debugDescription
    }
}

extension RegularExpression: CustomStringConvertible {
    public var description: String {
        return pattern.description
    }
}

extension RegularExpression: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.init(stringLiteral)
    }
}

extension RegularExpression: LosslessStringConvertible {
    public init(_ text: String) {
        self.init(pattern: text)
    }
}

extension RegularExpression: ObjectiveCBridgeable {
    public typealias _ObjectiveCType = NSRegularExpression

    public static func bridgeFromObjectiveC(_ source: ObjectiveCType) throws -> Self {
        .init(pattern: source.pattern, options: source.options)
    }
    
    public func bridgeToObjectiveC() throws -> ObjectiveCType {
        try .init(pattern: pattern, options: options)
    }
}

extension RegularExpression: StringInitiable, StringRepresentable {
    public var stringValue: String {
        pattern
    }
    
    public init(stringValue: String) {
        self.init(pattern: stringValue)
    }
}

// MARK: - API -

infix operator =~: ComparisonPrecedence
infix operator !~: ComparisonPrecedence

extension RegularExpression {
    public static func =~ (lhs: String, rhs: RegularExpression) -> Bool {
        return lhs.matches(rhs)
    }
    
    public static func !~ (lhs: String, rhs: RegularExpression) -> Bool {
        return !(lhs =~ rhs)
    }
}
