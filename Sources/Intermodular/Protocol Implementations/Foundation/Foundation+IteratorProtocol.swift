//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSEnumerator: _opaque_IteratorProtocol, IteratorProtocol {
    public typealias Element = Any
    
    public final func next() -> Element? {
        return nextObject()
    }
}
