//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

open class NSModernKeyedArchiver: NSKeyedArchiver {
    open var allEncodedKeys = Set<String>()

    override open func encode(_ object: Any?, forKey key: String) {
        super.encode(object, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encodeConditionalObject(_ object: Any?, forKey key: String) {
        super.encodeConditionalObject(object, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encode(_ value: Bool, forKey key: String) {
        super.encode(value, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encode(_ value: Int32, forKey key: String) {
        super.encode(value, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encode(_ value: Int64, forKey key: String) {
        super.encode(value, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encode(_ value: Float, forKey key: String) {
        super.encode(value, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encode(_ value: Double, forKey key: String) {
        super.encode(value, forKey: key)

        allEncodedKeys.insert(key)
    }

    override open func encodeBytes(_ bytes: UnsafePointer<UInt8>?, length: Int, forKey key: String) {
        print()
        super.encodeBytes(bytes, length: length, forKey: key)

        allEncodedKeys.insert(key)
    }
}


