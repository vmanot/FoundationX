//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Data: MutableContiguousStorage {
    public func withBufferPointer<BP: InitiableBufferPointer & ConstantBufferPointer, T>(_ body: ((BP) throws -> T)) rethrows -> T where Element == BP.Element {
        return try withUnsafeBytes({ try body(reinterpretCast($0)) })
    }
    
    public mutating func withMutableBufferPointer<BP: InitiableBufferPointer, T>(_ body: ((BP) throws -> T)) rethrows -> T where Element == BP.Element {
        return try withUnsafeMutableBytes({ try body(reinterpretCast($0)) })
    }
}

extension NSData: ContiguousStorage {
    public typealias Element = Byte
    
    public func withBufferPointer<BP: InitiableBufferPointer & ConstantBufferPointer, T>(_ body: ((BP) throws -> T)) rethrows -> T where Element == BP.Element {
        return try body(.init(start: .init(bytes), count: length))
    }
}

extension NSMutableData: MutableContiguousStorage {
    public func withMutableBufferPointer<BP: InitiableMutableBufferPointer, T>(_ body: ((BP) throws -> T)) rethrows -> T where Element == BP.Element {
        return try body(.init(start: .init(mutableBytes), count: length))
    }
}
