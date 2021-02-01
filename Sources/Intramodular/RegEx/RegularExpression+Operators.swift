//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension RegularExpression {
    public func options(_ options: Options) -> Self {
        guard !options.isEmpty else {
            return self
        }
        
        return self
            .modifyPattern({ "(?\(options.modifiers.map({ String($0) }).joined()))" + $0 })
    }
    
    public func options(on onOptions: Options, off offOptions: Options) -> Self {
        guard !(onOptions.isEmpty && offOptions.isEmpty) else {
            return self
        }
        
        guard !offOptions.isEmpty else {
            return options(onOptions)
        }
        
        return self
            .modifyPattern {
                let onOptions = onOptions.modifiers.map({ String($0) }).joined()
                let offOptions = offOptions.modifiers.map({ String($0) }).joined()
                
                return "(?\(onOptions)-\(offOptions))" + $0
            }
            .nonCaptureGroup()
    }
    
    public func or(_ expression: Self) -> Self {
        self.nonCaptureGroup()
            .modifyPattern({ $0.appending("|") })
            .append(expression)
            .nonCaptureGroup()
    }
    
    public static func oneOf(_ expressions: [Self]) -> Self {
        Self(
            pattern: expressions.map({ $0.nonCaptureGroup().pattern }).separated(by: "|").joined(),
            options: expressions.reduce([], { $0.union($1.options) })
        )
        .nonCaptureGroup()
    }
    
    public func or(oneOf expressions: [Self]) -> Self {
        Self.oneOf(expressions.inserting(self))
    }
    
    public func remove(mode: Self) -> Self {
        modifyPattern({ "(?-\(mode))".appending($0) })
    }
    
    public func optional() -> Self {
        nonCaptureGroup().modifyPattern({ $0.appending("?") })
    }
    
    public func repeating(_ count: Int) -> Self {
        nonCaptureGroup().modifyPattern({ $0.appending("{\(count)}") })
    }
    
    public func repeating() -> Self {
        nonCaptureGroup().modifyPattern({ $0.appending("+") })
    }
}
