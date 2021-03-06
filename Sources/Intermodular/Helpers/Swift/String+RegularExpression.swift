//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension String {
    public func ranges(matchedBy expression: RegularExpression) -> [Range<String.Index>] {
        expression.matchRanges(in: self)
    }
    
    public func nsRanges(matchedBy expression: RegularExpression) -> [NSRange] {
        (expression as NSRegularExpression).matches(in: self, range: nsRangeBounds).map({ $0.range })
    }
}

extension String {
    public func matches(_ expression: RegularExpression) -> Bool {
        !ranges(matchedBy: expression).isEmpty
    }
    
    public func matches(theWholeOf expression: RegularExpression) -> Bool {
        ranges(matchedBy: expression).find({ $0 == self.bounds }) != nil
    }
}

extension String {
    public func matchAndCaptureRanges(with expression: RegularExpression) -> [(Range<String.Index>, [Range<String.Index>?])] {
        expression.matchAndCaptureRanges(in: self)
    }
    
    public func captureRanges(with expression: RegularExpression) -> [[Range<String.Index>?]] {
        expression.captureRanges(in: self)
    }
    
    public func captureFirstRanges(with expression: RegularExpression) -> [Range<String.Index>?] {
        expression.captureFirstRanges(in: self)
    }
}

extension String {
    public func matchAndCaptureSubstrings(with expression: RegularExpression) -> [(Substring, [Substring?])] {
        matchAndCaptureRanges(with: expression).map({ (self[$0.0], $0.1.optionalMap({ self[$0] })) })
    }
    
    public func substrings(matchedBy expression: RegularExpression) -> [Substring] {
        ranges(matchedBy: expression).map({ self[$0] })
    }
    
    public func strings(matchedBy expression: RegularExpression) -> [String] {
        substrings(matchedBy: expression).map(String.init)
    }
    
    public func captureSubstrings(with expression: RegularExpression) -> [[Substring?]] {
        captureRanges(with: expression).map({ $0.optionalMap({ self[$0] }) })
    }
    
    public func captureFirstSubstrings(with expression: RegularExpression) -> [Substring?] {
        captureFirstRanges(with: expression).optionalMap({ self[$0] })
    }
    
    public func captureFirstStrings(with expression: RegularExpression) -> [String?] {
        captureFirstSubstrings(with: expression).optionalMap(String.init)
    }
}

extension String {
    public mutating func replace(_ expression: RegularExpression, with other: String) {
        self = replacing(expression, with: other)
    }
    
    public func replacing(
        _ expression: RegularExpression,
        with other: String
    ) -> String {
        replacing(expression, withTemplate: NSRegularExpression.escapedTemplate(for: other))
    }
    
    public mutating func replace(
        _ expression: RegularExpression,
        withTemplate template: String
    ) {
        self = replacing(expression, withTemplate: template)
    }
    
    public func replacing(
        _ expression: RegularExpression,
        withTemplate template: String
    ) -> String {
        (expression as NSRegularExpression).stringByReplacingMatches(in: self, options: [], range: .init(0..<count), withTemplate: template)
    }
}

extension String {
    public mutating func replaceSubstrings(_ substrings: [Substring], with newSubstrings: [Substring]) {
        replaceSubranges(substrings.lazy.map({ $0.bounds }), with: newSubstrings)
    }
    
    public mutating func mutateSubstrings(
        matchedBy expression: RegularExpression,
        _ mutate: ((_ body: inout Substring, _ matches: [Substring?]) -> Void)
    ) {
        let matches = matchAndCaptureSubstrings(with: expression)
        var replacements: [Substring] = []
        
        for (match, captured) in matches {
            var match = match
            
            mutate(&match, captured)
            
            replacements.append(match)
        }
        
        replaceSubstrings(matches.lazy.map({ $0.0 }), with: replacements)
    }
    
    public mutating func replaceLines(matching expression: RegularExpression, with replacement: String) {
        replace(substrings: self.lines().filter({ $0.matches(expression) }), with: replacement)
    }
    
    public mutating func removeLines(matching expression: RegularExpression) {
        replaceLines(matching: expression, with: "")
    }
}
