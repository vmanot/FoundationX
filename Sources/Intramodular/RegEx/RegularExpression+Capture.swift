//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension RegularExpression {
    public func add(mode: RegularExpression.Options) -> RegularExpression {
        modifyPattern({ "(?\(mode))" + $0 })
    }
    
    public func or(_ expression: RegularExpression) -> RegularExpression {
        self.nonCaptureGroup()
            .modifyPattern({ $0.appending("|") })
            .append(expression)
            .nonCaptureGroup()
    }
    
    public static func oneOf(_ expressions: [RegularExpression]) -> RegularExpression {
        return RegularExpression(pattern: expressions.map({ $0.nonCaptureGroup().stringValue }).separated(by: "|").joined()).nonCaptureGroup()
    }
    
    public func or(oneOf expressions: [RegularExpression]) -> RegularExpression {
        RegularExpression.oneOf(expressions.inserting(self))
    }
    
    public func remove(mode: RegularExpression.Options) -> RegularExpression {
        modifyPattern({ "(?-\(mode))".appending($0) })
    }
    
    public func optional() -> RegularExpression {
        nonCaptureGroup().modifyPattern({ $0.appending("?") })
    }
    
    public func repeating(_ count: Int) -> RegularExpression {
        nonCaptureGroup().modifyPattern({ $0.appending("{\(count)}") })
    }
    
    public func repeating() -> RegularExpression {
        nonCaptureGroup().modifyPattern({ $0.appending("+") })
    }
}

extension RegularExpression {
    public func capture(_ expression: RegularExpression) -> RegularExpression {
        modifyPattern {
            $0 + expression.modifyPattern({ "(" + $0 + ")" }).pattern
        }
    }
    
    public func capture(_ closure: ((RegularExpression) -> RegularExpression)) -> RegularExpression {
        capture(closure(.init()))
    }
    
    public func capture(_ option: Target) -> RegularExpression {
        capture(RegEx.match(option))
    }
    
    public func capture(oneOf strings: String...) -> RegularExpression {
        return capture(.oneOf(strings))
    }
    
    public func capture(anyOf string: String) -> RegularExpression {
        capture(RegEx.match(anyOf: .string(string)))
    }
    
    public func capture(anyOf string: String, repeating count: Int) -> RegularExpression {
        capture(RegEx.match(anyOf: .string(string)).repeating(count))
    }
    
    public func capture(anyOf characterSet: CharacterSet) -> RegularExpression {
        capture(RegEx.match(anyOf: .characterSet(characterSet)))
    }
    
    public func capture(anyOf characterSet: CharacterSet, repeating count: Int) -> RegularExpression {
        capture(RegEx.match(anyOf: .characterSet(characterSet)).repeating(count))
    }
}

extension RegularExpression {
    var isContainedInNotCaptureGroup: Bool {
        (pattern[try: 0..<3] == "(?:") && (pattern.last == Character(")"))
    }
    
    func nonCaptureGroup() -> RegularExpression {
        guard pattern != "", isValid, !isContainedInNotCaptureGroup else {
            return self
        }
        
        return .init(pattern: "(?:" + pattern + ")")
    }
    
    func captureGroup() -> RegularExpression {
        decomposeNonCaptureGroupIfNecessary().modifyPattern({ "(".appending($0).appending(")" )})
    }
    
    private func decomposeNonCaptureGroupIfNecessary() -> RegularExpression {
        guard isContainedInNotCaptureGroup else {
            return self
        }
        
        var pattern = self.pattern
        
        pattern.removeFirst(3)
        pattern.remove(at: pattern.lastIndex)
        
        return .init(pattern: pattern)
    }
}
