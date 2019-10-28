//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSRange: BoundInitiableRangeProtocol, HalfOpenRangeProtocol {
    public typealias Bound = Int

    @inlinable
    public init(bounds: (lower: Bound, upper: Bound)) {
        self.init(location: bounds.lower, length: bounds.upper - bounds.lower)
    }
}
