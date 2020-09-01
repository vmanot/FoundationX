//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSMutableArray: DestructivelyMutableSequence {
    public func forEach<T>(mutating iterator: ((inout Element) throws -> T)) rethrows {
        for (index, _) in enumerated() {
            _ = try iterator(&self[index])
        }
    }
    
    public func forEach<T>(destructivelyMutating iterator: ((inout Element?) throws -> T)) rethrows {
        for (index, element) in enumerated() {
            var element: Element! = element
            
            _ = try iterator(&element)
            
            (element as Element?).collapse({ self[index] = $0 }, do: remove(element!))
        }
    }
}

extension NSMutableData: MutableSequence {
    public func forEach<T>(mutating iterator: ((inout Element) throws -> T)) rethrows {
        for (index, _) in enumerated() {
            _ = try iterator(&self[_position: index])
        }
    }
}

extension NSMutableSet: DestructivelyMutableSequence {
    public func forEach<T>(mutating iterator: ((inout Element) throws -> T)) rethrows {
        try forEach(destructivelyMutating: { try iterator(&$0!) })
    }
    
    public func forEach<T>(destructivelyMutating iterator: ((inout Element?) throws -> T)) rethrows {
        for element in self {
            var element: Element! = element
            
            remove(element!)
            
            _ = try iterator(&element)
            
            (element as Element?).collapse(add)
        }
    }
}
