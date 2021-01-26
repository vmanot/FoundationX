//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Substring {
    public func matches(_ expression: RegularExpression) -> Bool {
        String(self).matches(expression)
    }
    
    public func matches(theWholeOf expression: RegularExpression) -> Bool {
        String(self).matches(theWholeOf: expression)
    }
}
