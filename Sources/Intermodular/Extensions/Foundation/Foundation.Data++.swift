//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Data {
    public static func allocate(byteCount: Int, alignment: Int) -> Data {
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
        
        return Data(bytesNoCopy: buffer, count: byteCount, deallocator: .free)
    }
    
    public static func allocate(capacity count: Int) -> Data {
        let buffer = UnsafeMutablePointer<Element>.allocate(capacity: count)
        
        return Data(bytesNoCopy: buffer, count: count, deallocator: .free)
    }
    
    public init<BP: RawBufferPointer>(bytesNoCopy bytes: BP, deallocator: Deallocator) {
        if let baseAddress = bytes.baseAddress {
            self.init(bytesNoCopy: .init(bitPattern: baseAddress), count: numericCast(bytes.count), deallocator: deallocator)
        } else {
            self.init()
        }
    }
    
    public init<BP: RawBufferPointer>(bytesNoCopyNoDeallocate bytes: BP) {
        self.init(bytesNoCopy: bytes, deallocator: .none)
    }
    
    public static func manage<BP: RawBufferPointer>(_ bytes: BP) -> Data  {
        return Data(bytesNoCopy: bytes, deallocator: .free)
    }
}

extension Data {
    public init(keyedArchiveFrom encodeImpl: (NSCoder) -> (), requiringSecureCoding: Bool = true) {
        let archiver = NSModernKeyedArchiver(requiringSecureCoding: requiringSecureCoding)
        
        encodeImpl(archiver)
        
        archiver.finishEncoding()
        
        self = archiver.encodedData
    }
}
