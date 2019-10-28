//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSAttributedString: MutableConvertible {
    public var mutableRepresentation: NSMutableAttributedString {
        return .init(attributedString: self)
    }
}

extension NSCharacterSet: MutableConvertible {
    public var mutableRepresentation: NSMutableCharacterSet {
        return mutableCopy() as! NSMutableCharacterSet
    }
}

extension NSDictionary: MutableConvertible {
    public var mutableRepresentation: NSMutableDictionary {
        return .init(dictionary: self)
    }
}

extension NSData: MutableConvertible {
    public var mutableRepresentation: NSMutableData {
        return NSMutableData(data: self as Data)
    }
}

extension NSSet: MutableConvertible {
    public var mutableRepresentation: NSMutableSet {
        return .init(set: self)
    }
}

extension NSString: MutableConvertible {
    public var mutableRepresentation: NSMutableString {
        return .init(string: self)
    }
}
