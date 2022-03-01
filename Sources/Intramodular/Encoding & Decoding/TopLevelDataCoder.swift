//
// Copyright (c) Vatsal Manot
//

import Combine
import Foundation
import Swallow

/// A type that defines methods for encoding & decoding data.
public protocol TopLevelDataCoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
    func encode<T: Encodable>(_ value: T) throws -> Data
}

// MARK: - Implementations -

public final class PropertyListCoder: TopLevelDataCoder {
    private let decoder = PropertyListDecoder()
    private let encoder = PropertyListEncoder()
    
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        try encoder.encode(value)
    }
}

extension TopLevelDataCoder where Self == PropertyListCoder {
    public static var propertyList: PropertyListCoder {
        PropertyListCoder()
    }
}

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

extension TopLevelDataCoder where Self == JSONCoder {
    public static var json: JSONCoder {
        JSONCoder()
    }
}
