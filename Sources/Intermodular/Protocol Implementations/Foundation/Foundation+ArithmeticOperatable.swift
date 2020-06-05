//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension CharacterSet: AdditionOperatable {
    public static func + (lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet {
        return lhs.union(rhs)
    }
    
    public static func += (lhs: inout CharacterSet, rhs: CharacterSet) {
        lhs = lhs + rhs
    }
}

extension Data: AdditionOperatable {
    
}

extension Decimal: ArithmeticOperatable {
    public static func += (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs + rhs
    }
    
    public static func -= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs - rhs
    }
    
    public static func *= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs * rhs
    }
    
    public static func /= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs / rhs
    }
    
    public static func % (lhs: Decimal, rhs: Decimal) -> Decimal {
        return ((lhs as NSDecimalNumber) % (lhs as NSDecimalNumber)) as Decimal
    }
    
    public static func %= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs % rhs
    }
}

extension NSCharacterSet {
    public static func + (lhs: NSCharacterSet, rhs: NSCharacterSet) -> NSCharacterSet {
        return NSMutableCharacterSet().applyingSelfOn({ $0.formUnion(with: lhs as CharacterSet); $0.formUnion(with: rhs as CharacterSet) })
    }
    
    public static func += (lhs: inout NSCharacterSet, rhs: NSCharacterSet) {
        lhs = lhs + rhs
    }
}

extension NSDecimalNumber {
    public static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.adding(rhs)
    }
    
    public static func += (lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs + rhs
    }
    
    public static func - (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.subtracting(rhs)
    }
    
    public static func -= (lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs - rhs
    }
    
    public static func * (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.multiplying(by: rhs)
    }
    
    public static func *= (lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs * rhs
    }
    
    public static func / (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.dividing(by: rhs)
    }
    
    public static func /= (lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs / rhs
    }
    
    public static func % (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.remainder(dividingBy: rhs)
    }
    
    public static func %= (lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs % rhs
    }
}
