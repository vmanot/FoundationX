//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension NSRegularExpression.Options {
    public var modeModifier: Character {
        switch self {
            case .caseInsensitive:
                return "i"
            case .allowCommentsAndWhitespace:
                return "x"
            case .ignoreMetacharacters:
                return "U"
            case .dotMatchesLineSeparators:
                return "s"
            case .anchorsMatchLines:
                return "m"
            case .useUnixLineSeparators:
                return "d"
            case .useUnicodeWordBoundaries:
                return "u"
            
            default:
                break
        }
        
        return impossible()
    }
    
    public init?(modeModifier: Character) {
        switch modeModifier {
            case "d":
                self = .useUnixLineSeparators
            case "i":
                self = .caseInsensitive
            case "x":
                self = .allowCommentsAndWhitespace
            case "m":
                self = .anchorsMatchLines
            case "s":
                self = .dotMatchesLineSeparators
            case "u":
                self = .useUnicodeWordBoundaries
            case "U":
                self = .ignoreMetacharacters
                
            default:
                return nil
        }
    }
}
