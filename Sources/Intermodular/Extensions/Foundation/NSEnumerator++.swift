//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension NSEnumerator {
    public class func emptyEnumerator() -> NSEnumerator {
        return NSArray().objectEnumerator()
    }
}
