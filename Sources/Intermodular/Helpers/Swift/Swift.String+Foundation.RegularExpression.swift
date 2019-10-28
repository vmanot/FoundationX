//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension String {
    public func matches(_ expression: RegularExpression) -> Bool {
        return !matchRanges(with: expression).isEmpty
    }

    public func wholeMatches(_ expression: RegularExpression) -> Bool {
        return matchRanges(with: expression).find({ $0 == self.bounds }) != nil
    }
}

extension String {
    public func matchAndCaptureRanges(with expression: RegularExpression) -> [(Range<String.Index>, [Range<String.Index>?])] {
        return expression.matchAndCaptureRanges(in: self)
    }

    public func matchRanges(with expression: RegularExpression) -> [Range<String.Index>] {
        return expression.matchRanges(in: self)
    }

    public func captureRanges(with expression: RegularExpression) -> [[Range<String.Index>?]] {
        return expression.captureRanges(in: self)
    }

    public func captureFirstRanges(with expression: RegularExpression) -> [Range<String.Index>?] {
        return expression.captureFirstRanges(in: self)
    }
}

extension String {
    public func matchAndCaptureSubstrings(with expression: RegularExpression) -> [(Substring, [Substring?])] {
        return matchAndCaptureRanges(with: expression).map({ (self[$0.0], $0.1.optionalMap({ self[$0] })) })
    }

    public func matchSubstrings(with expression: RegularExpression) -> [Substring] {
        return matchRanges(with: expression).map({ self[$0] })
    }

    public func matchStrings(with expression: RegularExpression) -> [String] {
        return matchSubstrings(with: expression).map(String.init)
    }

    public func captureSubstrings(with expression: RegularExpression) -> [[Substring?]] {
        return captureRanges(with: expression).map({ $0.optionalMap({ self[$0] }) })
    }

    public func captureFirstSubstrings(with expression: RegularExpression) -> [Substring?] {
        return captureFirstRanges(with: expression).optionalMap({ self[$0] })
    }

    public func captureFirstStrings(with expression: RegularExpression) -> [String?] {
        return captureFirstSubstrings(with: expression).optionalMap(String.init)
    }
}

extension String {
    public mutating func replace(_ expression: RegularExpression, with other: String) {
        self = replacing(expression, with: other)
    }

    public func replacing(_ expression: RegularExpression, with other: String) -> String {
        return expression.replace(in: self, with: other)
    }

    public mutating func replace(_ expression: RegularExpression, withTemplate template: String) {
        self = replacing(expression, withTemplate: template)
    }

    public func replacing(_ expression: RegularExpression, withTemplate template: String) -> String {
        return expression.replace(in: self, withTemplate: template)
    }
}

extension String {
    public mutating func replaceSubstrings(_ substrings: [Substring], with newSubstrings: [Substring]) {
        replaceSubranges(substrings.lazy.map({ $0.bounds }), with: newSubstrings)
    }

    public mutating func rewriteSubstrings(matchedBy regex: RegularExpression, f: ((_ body: inout Substring, _ matches: [Substring?]) -> Void)) {
        let matches = matchAndCaptureSubstrings(with: regex)
        var replacements: [Substring] = []

        for (match, captured) in matches {
            var match = match

            f(&match, captured)

            replacements.append(match)
        }

        replaceSubstrings(matches.lazy.map({ $0.0 }), with: replacements)
    }

    public mutating func replaceLines(matching expression: RegularExpression, with string: String) {
        let lines = self.lines().filter({ $0.matches(expression) })

        replace(substrings: lines, with: string)
    }

    public mutating func removeLines(matching expression: RegularExpression) {
        replaceLines(matching: expression, with: "")
    }
}
