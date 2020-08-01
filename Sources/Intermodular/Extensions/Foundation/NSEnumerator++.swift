//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSEnumerator {
    public class func emptyEnumerator() -> NSEnumerator {
        return NSArray().objectEnumerator()
    }
}
