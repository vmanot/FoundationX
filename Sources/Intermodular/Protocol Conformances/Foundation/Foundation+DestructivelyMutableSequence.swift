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
    
    public func forEach<T>(
        destructivelyMutating iterator: ((inout Element?) throws -> T)
    ) rethrows {
        TODO.whole(.test)
        
        for (index, element) in enumerated() {
            var newElement: Element? = element
            
            _ = try iterator(&newElement)
            
            if let newElement = newElement {
                self[index] = newElement
            } else {
                remove(element)
            }
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
    
    public func forEach<T>(
        destructivelyMutating iterator: ((inout Element?) throws -> T)
    ) rethrows {
        for element in self {
            var newElement: Element? = element
            
            remove(element)
            
            _ = try iterator(&newElement)
            
            if let newElement = newElement {
                add(newElement)
            }
        }
    }
}
