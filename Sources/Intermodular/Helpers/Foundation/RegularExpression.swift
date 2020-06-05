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

    public init(pattern: String, options: Options = []) {
        self.pattern = pattern
        self.options = options
    }

    public init() {
        self.init(pattern: .init())
    }
}

// MARK: - Extensions -

extension RegularExpression {
    public func matchAndCaptureRanges(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [(Range<String.Index>, [Range<String.Index>?])] {
        var result = [(Range<String.Index>, [Range<String.Index>?])]()

        let matches = value.matches(
            in: string,
            options: options,
            range: NSRange(string.bounds, in: string)
        )

        for match in matches {
            let matchedString = string[match.range]
            let captured = (1..<match.numberOfRanges).map(match.range(at:)).map({ Range($0, in: string) })

            result.append((matchedString.bounds, captured))
        }

        return result
    }

    public func matchAndCaptureSubstrings(in string: String) -> [(Substring, [Substring])] {
        var result = [(Substring, [Substring])]()

        let matches = value.matches(in: string, options: .reportCompletion, range: NSRange(string.bounds, in: string))

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
        return value
            .matches(in: string, range: string.nsRangeBounds)
            .map({ Range($0.range, in: string)! })
    }
}

extension RegularExpression {
    public func captureRanges(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [[Range<String.Index>?]] {
        var matches: [[Range<String.Index>?]] = []

        value.enumerateMatches(in: string, options: options, range: string.nsRangeBounds) { result, flags, stop in
            if let result = result {
                matches.append(result.ranges(in: string))
            }
        }

        return matches
    }

    public func captureGroups(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [[Substring?]] {
        return captureRanges(in: string, options: options).map({ $0.optionalMap({ string[$0] }) })
    }
}

extension RegularExpression {
    public func captureFirstRanges(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [Range<String.Index>?] {
        return value.firstMatch(in: string, options: options, range: string.nsRangeBounds)?.ranges(in: string) ?? []
    }

    public func captureFirstGroups(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [Substring?] {
        return captureFirstRanges(in: string, options: options).optionalMap({ string[$0] })
    }
}

// MARK: - Rubbish Extensions -

extension RegularExpression {
    public func replace(in string: String, withTemplate template: String) -> String {
        return value.stringByReplacingMatches(in: string, options: [], range: .init(0..<string.count), withTemplate: template)
    }

    public func replace(in substring: Substring, in other: String, withTemplate template: String) -> String {
        return value.stringByReplacingMatches(in: other, options: [], range: NSRange(other.range(of: substring)!, in: other), withTemplate: template)
    }

    public func replace(in string: String, with other: String) -> String {
        return replace(in: string, withTemplate: NSRegularExpression.escapedTemplate(for: other))
    }
}

// MARK: - Protocol Implementations -

extension RegularExpression: AdditionOperatable {
    @inlinable
    public static func + (lhs: RegularExpression, rhs: RegularExpression) -> RegularExpression {
        return .init(pattern: lhs.pattern + rhs.pattern)
    }

    @inlinable
    public static func += (lhs: inout RegularExpression, rhs: RegularExpression) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func + (lhs: RegularExpression, rhs: String) -> RegularExpression {
        return lhs + .init(rhs)
    }

    @inlinable
    public static func += (lhs: inout RegularExpression, rhs: String) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func + (lhs: String, rhs: RegularExpression) -> RegularExpression {
        return .init(lhs) + rhs
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

extension RegularExpression: Wrapper {
    public typealias Value = NSRegularExpression

    public var value: Value {
        return try! NSRegularExpression(pattern: pattern, options: options)
    }

    public init(_ value: Value) {
        self.init(pattern: value.pattern, options: value.options)
    }
}

extension RegularExpression: LosslessStringConvertible {
    public init(_ text: String) {
        self.init(pattern: text)
    }
}

extension RegularExpression: StringConvertible {
    public var stringValue: String {
        return pattern
    }
}

extension RegularExpression: StringInitiable {
    public init(stringValue: String) {
        self.init(pattern: stringValue)
    }
}

// MARK: - Helpers -

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
