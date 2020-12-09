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
