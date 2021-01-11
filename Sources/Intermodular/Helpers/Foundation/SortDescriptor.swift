//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public struct SortDescriptor: Codable, Hashable {
    public let keyPath: String
    public let direction: SortDirection
}

// MARK: - Protocol Conformances -

extension SortDescriptor: ObjectiveCBridgeable {
    public typealias _ObjectiveCType = NSSortDescriptor
    public typealias ObjectiveCType = NSSortDescriptor
    
    public static func bridgeFromObjectiveC(_ source: ObjectiveCType) throws -> Self {
        throw Never.Reason.unavailable
    }
    
    public func bridgeToObjectiveC() throws -> ObjectiveCType {
        NSSortDescriptor(key: keyPath, ascending: direction == .ascending)
    }
}
