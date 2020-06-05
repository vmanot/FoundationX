//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension NSRegularExpression.Options: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.init(modeModifier: Character(stringLiteral))!
    }
}
