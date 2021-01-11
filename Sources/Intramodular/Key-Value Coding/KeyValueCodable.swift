//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

protocol KeyValueCodable {
    static func decode(from _: KeyValueCoder, forKey _: String) throws -> Self
    
    func encode(to _: KeyValueCoder, forKey _: String) throws
}

protocol PrimitiveKeyValueCodable: KeyValueCodable {
    
}

// MARK: - Implementation -

extension PrimitiveKeyValueCodable {
    static func decode(from coder: KeyValueCoder, forKey key: String) throws -> Self {
        try cast(coder.value(forKey: key).unwrap(), to: Self.self)
    }
    
    func encode(to coder: KeyValueCoder, forKey key: String) throws {
        coder.setValue(self, forKey: key)
    }
}

// MARK: - Conditional Conformances -

extension Optional: KeyValueCodable where Wrapped: KeyValueCodable {
    static func decode(from coder: KeyValueCoder, forKey key: String) throws -> Self {
        if coder.value(forKey: key) == nil {
            return .none
        } else {
            return try Wrapped.decode(from: coder, forKey: key)
        }
    }
    
    func encode(to coder: KeyValueCoder, forKey key: String) throws {
        if let wrappedValue = self {
            try wrappedValue.encode(to: coder, forKey: key)
        } else {
            coder.removeObject(forKey: key)
        }
    }
}

// MARK: - Conformances -

extension Bool: PrimitiveKeyValueCodable {
    
}

extension Double: PrimitiveKeyValueCodable {
    
}

extension Float: PrimitiveKeyValueCodable {
    
}

extension Int: PrimitiveKeyValueCodable {
    
}

extension Int8: PrimitiveKeyValueCodable {
    
}

extension Int16: PrimitiveKeyValueCodable {
    
}

extension Int32: PrimitiveKeyValueCodable {
    
}

extension Int64: PrimitiveKeyValueCodable {
    
}

extension String: PrimitiveKeyValueCodable {
    
}

extension UInt: PrimitiveKeyValueCodable {
    
}

extension UInt8: PrimitiveKeyValueCodable {
    
}

extension UInt16: PrimitiveKeyValueCodable {
    
}

extension UInt32: PrimitiveKeyValueCodable {
    
}

extension UInt64: PrimitiveKeyValueCodable {
    
}

extension URL: KeyValueCodable {
    static func decode(from coder: KeyValueCoder, forKey key: String) throws -> Self {
        try URL(string: try String.decode(from: coder, forKey: key)).unwrap()
    }
    
    public func encode(to coder: KeyValueCoder, forKey key: String) throws {
        coder.setValue(path, forKey: key)
    }
}
