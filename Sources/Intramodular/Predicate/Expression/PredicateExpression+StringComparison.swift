//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

extension PredicateExpression where Value == String {
    public func isEqualTo(_ string: String, _ options: ComparisonPredicate.Options) -> Predicate<Root> {
        .comparison(.init(self, .equal, string, options))
    }
    
    public func beginsWith(_ string: String, _ options: ComparisonPredicate.Options = .caseInsensitive) -> Predicate<Root> {
        .comparison(.init(self, .beginsWith, string, options))
    }
    
    public func contains(_ string: String, _ options: ComparisonPredicate.Options = .caseInsensitive) -> Predicate<Root> {
        .comparison(.init(self, .contains, string, options))
    }
    
    public func endsWith(_ string: String, _ options: ComparisonPredicate.Options = .caseInsensitive) -> Predicate<Root> {
        .comparison(.init(self, .endsWith, string, options))
    }
    
    public func like(_ string: String, _ options: ComparisonPredicate.Options = .caseInsensitive) -> Predicate<Root> {
        .comparison(.init(self, .like, string, options))
    }
    
    public func matches(_ regex: NSRegularExpression, _ options: ComparisonPredicate.Options = .caseInsensitive) -> Predicate<Root> {
        .comparison(.init(self, .matches, regex.pattern, options))
    }
}
