//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

protocol UserDefaultsCoder {
    static func decode(from _: UserDefaults, forKey _: String) throws -> Self
    
    func encode(to _: UserDefaults, forKey _: String) throws
}

protocol UserDefaultsPrimitive: UserDefaultsCoder {
    
}

// MARK: - Implementation -

extension UserDefaultsPrimitive {
    static func decode(from defaults: UserDefaults, forKey key: String) throws -> Self {
        try cast(defaults.value(forKey: key).unwrap(), to: Self.self)
    }
    
    func encode(to defaults: UserDefaults, forKey key: String) throws {
        defaults.setValue(self, forKey: key)
    }
}

// MARK: - Conditional Conformances -

extension Optional: UserDefaultsCoder where Wrapped: UserDefaultsCoder {
    static func decode(from defaults: UserDefaults, forKey key: String) throws -> Self {
        if defaults.value(forKey: key) == nil {
            return .none
        } else {
            return try Wrapped.decode(from: defaults, forKey: key)
        }
    }
    
    func encode(to defaults: UserDefaults, forKey key: String) throws {
        if let wrappedValue = self {
            try wrappedValue.encode(to: defaults, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }
}

// MARK: - Conformances -

extension Bool: UserDefaultsPrimitive {
    
}

extension Double: UserDefaultsPrimitive {
    
}

extension Float: UserDefaultsPrimitive {
    
}

extension Int: UserDefaultsPrimitive {
    
}

extension Int8: UserDefaultsPrimitive {
    
}

extension Int16: UserDefaultsPrimitive {
    
}

extension Int32: UserDefaultsPrimitive {
    
}

extension Int64: UserDefaultsPrimitive {
    
}

extension String: UserDefaultsPrimitive {
    
}

extension UInt: UserDefaultsPrimitive {
    
}

extension UInt8: UserDefaultsPrimitive {
    
}

extension UInt16: UserDefaultsPrimitive {
    
}

extension UInt32: UserDefaultsPrimitive {
    
}

extension UInt64: UserDefaultsPrimitive {
    
}

extension URL: UserDefaultsCoder {
    static func decode(from defaults: UserDefaults, forKey key: String) throws -> Self {
        try URL(string: try String.decode(from: defaults, forKey: key)).unwrap()
    }
    
    public func encode(to defaults: UserDefaults, forKey key: String) throws {
        defaults.setValue(path, forKey: key)
    }
}
