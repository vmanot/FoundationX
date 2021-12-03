//
// Copyright (c) Vatsal Manot
//

import Combine

/// A type that defines methods for encoding & decoding data.
public protocol TopLevelDataCoder: TopLevelEncoder, TopLevelDecoder where Input == Data, Output == Data {
    
}

extension TopLevelDataCoder where Self == JSONCoder {
    public static var json: JSONCoder {
        JSONCoder()
    }
}

// MARK: - Implementations -

public final class JSONCoder: TopLevelDataCoder {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        try encoder.encode(value)
    }
}
