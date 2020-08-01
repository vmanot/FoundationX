//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value
    public let defaults: UserDefaults
    
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
    
    public var wrappedValue: Value {
        get {
            if Value.self is AnyClass {
                return defaults.object(forKey: key) as? Value ?? defaultValue
            } else {
                return defaults.value(forKey: key) as? Value ?? defaultValue
            }
        } set {
            defaults.set(newValue, forKey: key)
        }
    }
}
