//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

@objc protocol NSSequence {
    func objectEnumerator() -> NSEnumerator
}
