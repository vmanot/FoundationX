//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

public enum Gender: String, Codable {
    case male
    case female
    case other
    
    public var title: String {
        switch self {
            case .male:
                return "Male"
            case .female:
                return "Female"
            case .other:
                return "Other"
        }
    }
}
