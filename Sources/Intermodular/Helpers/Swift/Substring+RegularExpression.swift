//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension Substring {
    public func matches(_ expression: RegularExpression) -> Bool {
        return String(self).matches(expression)
    }

    public func wholeMatches(_ expression: RegularExpression) -> Bool {
        return String(self).wholeMatches(expression)
    }
}

extension Substring {
    public func matchAndCaptureRanges(with expression: RegularExpression) -> [(Range<String.Index>, [Range<String.Index>?])] {
        return parent
            .matchAndCaptureRanges(with: expression)
            .filter({ bounds.contains($0.0) })
    }

    public func matchRanges(with expression: RegularExpression) -> [Range<String.Index>] {
        return parent
            .matchRanges(with: expression)
            .filter({ bounds.contains($0) })
    }
}

extension Substring {
    public func replacing(_ expression: RegularExpression, with other: String) -> String {
        return String(self).replacing(expression, with: other)
    }

    public func replacing(_ expression: RegularExpression, withTemplate template: String) -> String {
        return String(self).replacing(expression, withTemplate: template)
    }
}
