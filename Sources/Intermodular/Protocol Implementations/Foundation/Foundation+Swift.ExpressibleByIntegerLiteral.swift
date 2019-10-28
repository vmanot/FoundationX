//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension IndexPath: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(index: value)
    }
}

extension IndexSet: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(integer: value)
    }
}

extension NSRange: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
