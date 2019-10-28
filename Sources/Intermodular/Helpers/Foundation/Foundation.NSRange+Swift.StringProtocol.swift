//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension String {
    public subscript(range: NSRange) -> Substring {
        return self[Range(range, in: self).orFatallyThrow("invalid range \(range)")]
    }
}

extension Substring {
    public subscript(range: NSRange) -> Substring {
        return self[Range(range, in: self.parent).orFatallyThrow("invalid range \(range)")]
    }
}

extension Sequence where Element == Range<String.Index> {
    public func toNSRanges(in string: String) -> [NSRange] {
        return map({ NSRange($0, in: string) })
    }
}
