//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension Date {
    public var dd_dot_MM_dot_YYYY: String {
        DateFormatter()
            .then { $0.dateFormat = "dd.MM.yyyy" }
            .string(from: self)
    }
    
    public var hh_colon_mm_colon_space_a: String {
        DateFormatter()
            .then { $0.dateFormat = "hh:mm a" }
            .string(from: self)
    }
    
    public var hh_colon_mm_colon_ss_space_a: String {
        DateFormatter()
            .then { $0.dateFormat = "hh:mm:ss a" }
            .string(from: self)
    }
}
