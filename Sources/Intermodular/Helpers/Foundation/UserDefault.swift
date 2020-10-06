//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

@propertyWrapper
public struct UserDefault<Value: Codable> {
    public let key: String
    public let defaultValue: Value
    public let defaults: UserDefaults
    
    public var wrappedValue: Value {
        get {
            try! defaults.decode(Value.self, forKey: key) ?? defaultValue
        } set {
            try! defaults.encode(newValue, forKey: key)
        }
    }
    
    public init(
        key: String,
        defaultValue: Value,
        defaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
    }
    
    public init<T>(
        key: String,
        defaults: UserDefaults = .standard
    ) where Value == Optional<T> {
        self.init(key: key, defaultValue: .none, defaults: defaults)
    }
}
