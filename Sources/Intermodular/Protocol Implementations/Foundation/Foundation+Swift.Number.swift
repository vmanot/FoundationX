//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Decimal: Continuous, Signed, Number {
    @inlinable
    @inline(__always)
    public var isNegative: Bool {
        return _isNegative.toBool()
    }

    @inlinable
    @inline(__always)
    public init(uncheckedOpaqueValue value: opaque_Number) {
        self = value.toDecimal()
    }

    @inlinable
    @inline(__always)
    public init<N: opaque_Number>(unchecked value: N) {
        self = value.toDecimal()
    }
}
