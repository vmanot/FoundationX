//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

@propertyWrapper
public struct UserDefault<Value: Codable> {
    public let key: String
    public let defaultValue: Value
    public let store: UserDefaults
    
    public var wrappedValue: Value {
        get {
            try! store.decode(Value.self, forKey: key) ?? defaultValue
        } set {
            try! store.encode(newValue, forKey: key)
        }
    }
    
    public init(
        _ key: String,
        default defaultValue: Value,
        store: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.store = store
    }
    
    public init<T>(
        _ key: String,
        store: UserDefaults = .standard
    ) where Value == Optional<T> {
        self.init(key, default: .none, store: store)
    }
}
