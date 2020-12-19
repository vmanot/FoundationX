//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension RegularExpression {
    public var isWrappedInNonCapturingGroup: Bool {
        return (pattern[try: 0..<3] == "(?:") && (pattern.last == ")")
    }

    public func wrappedInNonCapturingGroup() -> RegularExpression {
        guard pattern != "", isValid, !isWrappedInNonCapturingGroup else {
            return self
        }
        
        return .init(pattern: "(?:" + pattern + ")")
    }
    
    public func unwrappedIfInNonCapturingGroup() -> RegularExpression {
        guard isWrappedInNonCapturingGroup else {
            return self
        }
        
        var pattern = self.pattern

        pattern.removeFirst(3)
        pattern.remove(at: pattern.lastIndex)
        
        return .init(pattern: pattern)
    }
    
    public func wrappedInCapturingGroup() -> RegularExpression {
        let body = isWrappedInNonCapturingGroup ? unwrappedIfInNonCapturingGroup() : self
        
        return body.add(toStartOfPattern: "(").add(toEndOfPattern: ")'")
    }
}

extension RegularExpression {
    public func add(toEndOfPattern other: String) -> RegularExpression {
        return .init(pattern: pattern + other)
    }
    
    public func add(toStartOfPattern other: String) -> RegularExpression {
        return .init(pattern: other + pattern)
    }

    public func add(mode: RegularExpression.Options) -> RegularExpression {
        return add(toStartOfPattern: "(?\(mode))")
    }
    
    public func add(_ expression: String) -> RegularExpression {
        return add(RegularExpression(expression))
    }
    
    public func add(_ expression: RegularExpression) -> RegularExpression {
        return self + expression
    }
    
    public func or(_ expression: RegularExpression) -> RegularExpression {
        return wrappedInNonCapturingGroup().add(toEndOfPattern: "|").add(expression).wrappedInNonCapturingGroup()
    }
    
    public static func oneOf(_ expressions: [RegularExpression]) -> RegularExpression {
        let string = expressions.map({ $0.wrappedInNonCapturingGroup().stringValue }).separated(by: "|").joined()
        
        return RegularExpression(string).wrappedInNonCapturingGroup()
    }
    
    public func or(oneOf expressions: [RegularExpression]) -> RegularExpression {
        return RegularExpression.oneOf(expressions.inserting(self))
    }

    public func removing(mode: RegularExpression.Options) -> RegularExpression {
        return add(toStartOfPattern: "(?-\(mode))")
    }
    
    public func makingSelfOptional() -> RegularExpression {
        return wrappedInNonCapturingGroup().add(toEndOfPattern: "?")
    }
    
    public func repeating(_ count: Int) -> RegularExpression {
        return wrappedInNonCapturingGroup().add(toEndOfPattern: "{\(count)}")
    }
    
    public func repeating() -> RegularExpression {
        return wrappedInNonCapturingGroup().add(toEndOfPattern: "+")
    }
}

extension String {
    public var sanitizedForRegularExpression: String {
        return NSRegularExpression.escapedPattern(for: self)
    }
}

extension RegularExpression {
    public func capture(_ closure: ((RegularExpression) -> RegularExpression)) -> RegularExpression {
        return self.add(
            toEndOfPattern: closure(.init())
                .add(toStartOfPattern: "(")
                .add(toEndOfPattern: ")").pattern
        )
    }
    
    public func capture(_ option: Target) -> RegularExpression {
        return capture({ $0.match(option) })
    }
    
    public func capture(anyOf string: String) -> RegularExpression {
        return capture({ $0.match(anyOf: .string(string)) })
    }
    
    public func capture(anyOf string: String, repeating count: Int) -> RegularExpression {
        return capture({ $0.match(anyOf: .string(string)).repeating(count) })
    }
    
    public func capture(anyOf characterSet: CharacterSet) -> RegularExpression {
        return capture({ $0.match(anyOf: .characterSet(characterSet)) })
    }
    
    public func capture(anyOf characterSet: CharacterSet, repeating count: Int) -> RegularExpression {
        return capture({ $0.match(anyOf: .characterSet(characterSet)).repeating(count) })
    }
}
