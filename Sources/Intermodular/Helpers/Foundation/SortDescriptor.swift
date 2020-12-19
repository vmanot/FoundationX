//
// Copyright (c) Vatsal Manot
//

import Swift

public struct SortDescriptor: Codable, Hashable {
    public let key: String
    public let direction: SortDirection
}
