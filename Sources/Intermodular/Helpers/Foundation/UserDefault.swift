//
// Copyright (c) Vatsal Manot
//

import Combine
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

extension UserDefault {
    @propertyWrapper
    public struct Published {
        @UserDefault
        public var wrappedValue: Value
        
        @inlinable
        public static subscript<EnclosingSelf: ObservableObject>(
            _enclosingInstance object: EnclosingSelf,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
            storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Published>
        ) -> Value where EnclosingSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
            get {
                object[keyPath: storageKeyPath].wrappedValue
            } set {
                object.objectWillChange.send()
                
                object[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
        
        public init(
            wrappedValue: Value,
            _ key: String,
            store: UserDefaults = .standard
        ) {
            self._wrappedValue = .init(key, default: wrappedValue, store: store)
        }
        
        public init<T>(
            _ key: String,
            store: UserDefaults = .standard
        ) where Value == Optional<T> {
            self.init(wrappedValue: .none, key, store: store)
        }
    }
}
