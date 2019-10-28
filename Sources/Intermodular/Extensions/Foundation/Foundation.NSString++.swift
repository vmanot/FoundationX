//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSString {
    public convenience init?(bytes: UnsafeRawPointer, length: Int, encoding: String.Encoding) {
        self.init(bytes: bytes, length: length, encoding: encoding.rawValue)
    }
}
