//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension RegularExpression {
    public func capture(_ expression: Self, named name: String? = nil) -> Self {
        self + expression.captureGroup(named: name)
    }
    
    public func capture(_ name: String? = nil, _ closure: ((Self) -> Self)) -> Self {
        capture(closure(.init()), named: name)
    }
    
    public func capture(_ option: Target, named name: String? = nil) -> Self {
        capture(RegEx.match(option), named: name)
    }
    
    public func capture(oneOf strings: String...) -> Self {
        capture(.oneOf(strings))
    }
    
    public func capture(anyOf string: String) -> Self {
        capture(RegEx.match(anyOf: .string(string)))
    }
    
    public func capture(anyOf string: String, repeating count: Int) -> Self {
        capture(RegEx.match(anyOf: .string(string)).repeating(count))
    }
    
    public func capture(anyOf characterSet: CharacterSet) -> Self {
        capture(RegEx.match(anyOf: .characterSet(characterSet)))
    }
    
    public func capture(anyOf characterSet: CharacterSet, repeating count: Int) -> Self {
        capture(RegEx.match(anyOf: .characterSet(characterSet)).repeating(count))
    }
}

extension RegularExpression {
    public func captureRanges(
        in string: String,
        options: NSRegularExpression.MatchingOptions = []
    ) -> [[Range<String.Index>?]] {
        var matches: [[Range<String.Index>?]] = []
        
        (self as NSRegularExpression).enumerateMatches(in: string, options: options, range: string.nsRangeBounds) { result, flags, stop in
            if let result = result {
                matches.append(result.ranges(in: string))
            }
        }
        
        return matches
    }
    
    public func captureGroups(
        in string: String,
        options: NSRegularExpression.MatchingOptions = []
    ) -> [[Substring?]] {
        captureRanges(in: string, options: options).map({ $0.optionalMap({ string[$0] }) })
    }
    
    public func captureFirstRanges(
        in string: String,
        options: NSRegularExpression.MatchingOptions = []
    ) -> [Range<String.Index>?] {
        (self as NSRegularExpression).firstMatch(in: string, options: options, range: string.nsRangeBounds)?.ranges(in: string) ?? []
    }
    
    public func captureFirstGroups(
        in string: String,
        options: NSRegularExpression.MatchingOptions = []
    ) -> [Substring?] {
        captureFirstRanges(in: string, options: options).optionalMap({ string[$0] })
    }
    
    public func captureNamedGroups(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: NSRange? = nil
    ) -> [String: String] {
        let range = range ?? NSRange(location: 0, length: string.utf16.count)
        let regex = self as NSRegularExpression
        let names = regex.textCheckingResultsOfNamedCaptureGroups()
        
        var dict = [String: String]()
        let matchResult = regex.matches(in: string, options: options, range: range)
        
        for (_, m) in matchResult.enumerated() {
            for i in 0 ..< m.numberOfRanges {
                guard let g = Range(m.range(at: i), in: string).map({ string[$0] }) else {
                    continue
                }
                
                if let name = names.first(where: { $0.value.index == (i + 1) })?.key {
                    dict[name] = .init(g)
                }
            }
        }
        return dict
    }
}

// MARK: - Auxiliary Implementation -

fileprivate extension NSRegularExpression {
    typealias GroupNamesSearchResult = (NSTextCheckingResult, NSTextCheckingResult, index: Int)
    
    func textCheckingResultsOfNamedCaptureGroups() -> [String: GroupNamesSearchResult] {
        var result = [String: GroupNamesSearchResult]()
        
        guard let greg = try? NSRegularExpression(pattern: "^\\(\\?<([\\w\\a_-]*)>$", options: NSRegularExpression.Options.dotMatchesLineSeparators) else {
            return result
        }
        
        guard let reg = try? NSRegularExpression(pattern: "\\(.*?>", options: NSRegularExpression.Options.dotMatchesLineSeparators) else {
            return result
        }
        
        let m = reg.matches(
            in: pattern,
            options: NSRegularExpression.MatchingOptions.withTransparentBounds,
            range: NSRange(location: 0, length: pattern.utf16.count)
        )
        
        for (n, g) in m.enumerated() {
            let r = Range(g.range(at: 0), in: pattern)
            let gstring = String(pattern[r!])
            let gmatch = greg.matches(
                in: gstring,
                options: NSRegularExpression.MatchingOptions.anchored,
                range: NSRange(location: 0, length: gstring.utf16.count)
            )
            
            if gmatch.count > 0 {
                let r2 = Range(gmatch[0].range(at: 1), in: gstring)!
                result[String(gstring[r2])] = (g, gmatch[0], n)
            }
        }
        
        return result
    }
}

extension RegularExpression {
    var isNonCapturingGroupContained: Bool {
        (pattern[try: 0..<3] == "(?:") && (pattern.last == Character(")"))
    }
    
    func nonCaptureGroup() -> Self {
        guard pattern != "", isValid, !isNonCapturingGroupContained else {
            return self
        }
        
        return modifyPattern { pattern in
            "(?:" + pattern + ")"
        }
    }
    
    func captureGroup(named name: String?) -> Self {
        if let name = name {
            return decomposeNonCaptureGroupIfNecessary().modifyPattern {
                "(".appending("?<\(name)>").appending($0).appending(")")
            }
        } else {
            return decomposeNonCaptureGroupIfNecessary().modifyPattern {
                "(".appending($0).appending(")")
            }
        }
    }
    
    private func decomposeNonCaptureGroupIfNecessary() -> Self {
        guard isNonCapturingGroupContained else {
            return self
        }
        
        var pattern = self.pattern
        
        pattern.remove(at: pattern.lastIndex)
        pattern.removeFirst(3)
        
        return .init(pattern: pattern)
    }
}
