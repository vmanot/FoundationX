//
// Copyright (c) Vatsal Manot
//

import Foundation

public protocol KeyValueCoder {
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
    func removeObject(forKey key: String)
}

// MARK: - Implementation -

extension KeyValueCoder {
    public func removeObject(forKey key: String) {
        setValue(nil, forKey: key)
    }
}

// MARK: - Conformances -

#if canImport(CloudKit)

import CloudKit

extension CKRecord: KeyValueCoder {
    
}

#endif

#if canImport(CoreData)

import CoreData

extension NSManagedObject: KeyValueCoder {
    
}

#endif

extension UserDefaults: KeyValueCoder {
    
}
