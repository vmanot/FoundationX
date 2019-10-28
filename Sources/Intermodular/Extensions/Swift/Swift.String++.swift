//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension String {
    public var nsRangeBounds: NSRange {
        return NSRange(bounds, in: self)
    }
    
    public init?<BP: RawBufferPointer>(bytesNoCopy bytes: BP, encoding: String.Encoding, freeWhenDone: Bool) {
        guard !bytes.isEmpty else {
            return nil
        }
        
        self.init(
            bytesNoCopy: .init(bitPattern: bytes.baseAddress!),
            length: numericCast(bytes.count),
            encoding: encoding,
            freeWhenDone: freeWhenDone
        )
    }
    
    public func substring(withRange range: NSRange) -> Substring {
        let start = index(startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: range.length)
        
        return self[start..<end]
    }
}
