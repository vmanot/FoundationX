//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Decimal: BooleanInitiable {
    public init(_ value: Bool) {
        self.init(value as NSNumber)
    }
    
    public init(_ value: DarwinBoolean) {
        self.init(Bool(value))
    }
    
    public init(_ value: ObjCBool) {
        self.init(Bool(value))
    }
}
