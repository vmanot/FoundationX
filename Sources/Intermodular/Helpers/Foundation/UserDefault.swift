//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value
    public let defaults: UserDefaults

    public init(
        _ key: String,
        defaultValue: Value,
        defaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
    }

    public var wrappedValue: Value {
        get {
            return defaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
