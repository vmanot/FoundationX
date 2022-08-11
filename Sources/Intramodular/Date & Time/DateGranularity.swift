//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

/// The granularity of a `Date`.
public enum DateGranularity: String, Codable {
    case era
    case year
    case month
    case day
    case hour
    case minute
    case second
    case nanosecond
}
