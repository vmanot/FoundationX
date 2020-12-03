//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public protocol CacheProtocol {
    associatedtype Key: Hashable
    associatedtype Value
    
    func cache(_ value: Value, forKey key: Key) throws
    func decacheValue(forKey key: Key) throws -> Value?
    
    func removeCachedValue(forKey key: Key) throws
    func removeAllCachedValues() throws
}

public protocol Caching {
    associatedtype Cache: CacheProtocol
    
    var cache: Cache { get }
}

private var Caching_cache_objcAssociationKey: Void = ()

extension Caching where Self: AnyObject, Cache: Initiable {
    public var cache: Cache {
        if let result = objc_getAssociatedObject(self, &Caching_cache_objcAssociationKey) as? Cache {
            return result
        } else {
            let result = Cache()
            
            objc_setAssociatedObject(self, &Caching_cache_objcAssociationKey, result, .OBJC_ASSOCIATION_RETAIN)
            
            return result
        }
    }
}

// MARK: - Conformances -

public protocol _NoCacheType: Initiable & CacheProtocol {
    
}

public final class NoCache<Key: Hashable, Value>: _NoCacheType {
    public init() {
        
    }
    
    public func cache(_ value: Value, forKey key: Key) throws {
        
    }
    
    public func decacheValue(forKey key: Key) throws -> Value? {
        return nil
    }
    
    public func removeCachedValue(forKey key: Key) throws {
        
    }
    
    public func removeAllCachedValues() throws {
        
    }
}
