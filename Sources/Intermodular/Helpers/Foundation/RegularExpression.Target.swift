//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension RegularExpression {
    public enum Target {
        case allEnglishAlphabets
        case character(Character)
        case string(String)
        case zeroOrMore(String)
        case oneOf([String])
        case characterSet(CharacterSet)
        
        case anything
        case anythingNonGreedy
        case anythingBut(String)
        case something
        case somethingBut(String)
        
        case startOfLine
        case endOfLine
        
        case wordBoundary
        case word
        case singleNumber
        case number(digitsBetween: ClosedRange<Int>)
        
        case lineBreak
        case tabSpace
    }
}

extension RegularExpression.Target: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

// MARK: - Helpers -

extension RegularExpression.Target {
    public var rawValue: String {
        switch self {
            case .allEnglishAlphabets:
                return "[A-Za-z]"
            case .character(let value):
                return String(value)
            case .characterSet(let value):
                return String(value.value)
            case .string(let value):
                return value.sanitizedForRegularExpression
            case .zeroOrMore(let value):
                return "(?:\(value.sanitizedForRegularExpression))*"
            case .oneOf(let value):
                return "(?:\(value.map({ $0.sanitizedForRegularExpression }).joined(separator: "|")))"
            case .anything:
                return ".*"
            case .anythingNonGreedy:
                return ".*?"
            case .anythingBut(let value):
                return "[^\(value.sanitizedForRegularExpression)]*"
            case .something:
                return ".+"
            case .somethingBut(let value):
                return "[^\(value.sanitizedForRegularExpression)]+"
                
            case .startOfLine:
                return "^"
            case .endOfLine:
                return "$"
            case .wordBoundary:
                return "\\b"
            case .word:
                return "\\w+"
            case .singleNumber:
                return "\\d"
            case .number(let range):
                return "\\d{\(range.lowerBound),\(range.upperBound)}"
                
            case .lineBreak:
                return RegularExpression("\n").or(.init("\r\n")).stringValue
            case .tabSpace:
                return "\t"
        }
    }
}
extension RegularExpression {
    public func or(_ target: RegularExpression.Target) -> RegularExpression {
        return or(RegEx.match(target))
    }
    
    public func match(_ this: RegularExpression.Target, or other: RegularExpression.Target) -> RegularExpression {
        return add(RegEx.match(this).or(other))
    }
    
    public func match(_ this: RegularExpression.Target, or other: RegularExpression.Target, or other2: RegularExpression.Target) -> RegularExpression {
        return add(RegEx.match(this).or(other).or(other2))
    }
    
    public func match(_ option: RegularExpression.Target) -> RegularExpression {
        var result = self
        result += option.rawValue
        return result
    }
    
    public func match(oneOf strings: String...) -> RegularExpression {
        return match(.oneOf(strings))
    }
    
    public func capture(oneOf strings: String...) -> RegularExpression {
        return capture(.oneOf(strings))
    }
    
    public func match(anyOf target: RegularExpression.Target) -> RegularExpression {
        switch target {
            case .string(let value):
                return add("(?:[\(value.sanitizedForRegularExpression)])")
            case .characterSet(let value):
                return match(anyOf: .string(String(value.value)))
                
            default:
                _ = TODO.unimplemented
        }
    }
    
    public func match(maybe target: RegularExpression.Target) -> RegularExpression {
        return add("(?:\(target.rawValue))?")
    }
    
    public func match(_ closure: ((RegularExpression) -> RegularExpression)) -> RegularExpression {
        return add(toEndOfPattern: closure(.init()).add(toStartOfPattern: "(?:").add(toEndOfPattern: ")").pattern)
    }
}

extension RegularExpression {
    public typealias TargetSet = [RegularExpression.Target]
    
    public func match(_ options: TargetSet) -> RegularExpression {
        return RegularExpression.oneOf(options.map(RegEx.match(_:)))
    }
}

public func || (lhs: RegularExpression.Target, rhs: RegularExpression.Target) -> RegularExpression.TargetSet {
    return .init([lhs, rhs])
}

public func || (lhs: RegularExpression.TargetSet, rhs: RegularExpression.Target) -> RegularExpression.TargetSet {
    return .init(lhs.appending(rhs))
}
