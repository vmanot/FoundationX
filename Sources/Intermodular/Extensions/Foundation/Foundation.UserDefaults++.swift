//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension UserDefaults {
    @objc public dynamic subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        } set {
            set(newValue, forKey: key)
        }
    }
}
