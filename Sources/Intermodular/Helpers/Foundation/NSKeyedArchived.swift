//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

@propertyWrapper
public struct NSKeyedArchived<Value>: Codable {
    @MutableValueBox
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) where Value: NSCoding {
        self.wrappedValue = wrappedValue
    }
    
    public init<Wrapper: MutablePropertyWrapper>(wrappedValue: Wrapper) where Wrapper.WrappedValue == Value {
        self._wrappedValue = .init(wrappedValue)
    }
    
    @inlinable
    public init<T>(wrappedValue: Value) where T: NSCoding, Value == Optional<T> {
        self.wrappedValue = wrappedValue
    }
    
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let type = Value.self as? NSCoding.Type {
            wrappedValue = try type.init(coder: try NSKeyedUnarchiver(forReadingFrom: try container.decode(Data.self))).unwrap() as! Value
        } else {
            let type = (Value.self as! _opaque_Optional.Type)._opaque_Optional_Wrapped as! NSCoding.Type
            
            if container.decodeNil() {
                wrappedValue = (Value.self as! _opaque_Optional.Type).init(nilLiteral: ()) as! Value
            } else {
                wrappedValue = try type.init(coder: try NSKeyedUnarchiver(forReadingFrom: try container.decode(Data.self))).unwrap() as! Value
            }
        }
    }
    
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let wrappedValue = wrappedValue as? _opaque_Optional, wrappedValue.isNil {
            try container.encodeNil()
        } else {
            try container.encode(try NSKeyedArchiver.archivedData(withRootObject: wrappedValue as! NSCoding, requiringSecureCoding: wrappedValue is NSSecureCoding))
        }
    }
}

extension NSKeyedArchived: Equatable where Value: Equatable {
    public static func == (lhs: Self, rhs: Self) {
        
    }
}

extension NSKeyedArchived: Hashable where Value: Hashable {
    
}

extension NSKeyedArchived where Value: ExpressibleByNilLiteral & NSCoding {
    public init(nilLiteral: Void) {
        self.init(wrappedValue: .init(nilLiteral: ()))
    }
}
