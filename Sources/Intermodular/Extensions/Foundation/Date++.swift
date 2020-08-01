//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Date {
    /// Convert this date to a `String` given a certain format.
    public func toString(dateFormat format: String) -> String {
        DateFormatter()
            .then({ $0.dateFormat = format })
            .string(from: self)
    }
}

extension Date {
    /// Number of days (relative to this date) till a given date.
    public func days(till other: Date, in calendar: Calendar = .current) -> Int! {
        calendar.dateComponents([.day], from: self, to: other).day
    }
}

extension Date {
    /// `DD.MM.YYY`
    public var dd_dot_MM_dot_YYYY: String {
        toString(dateFormat: "dd.MM.yyyy")
    }
    
    public var hh_colon_mm_colon_space_a: String {
        toString(dateFormat: "hh:mm a")
    }
    
    public var hh_colon_mm_colon_ss_space_a: String {
        toString(dateFormat: "hh:mm:ss a")
    }
}

extension Date {
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    public var endOfDay: Date {
        var components = DateComponents()
        
        components.day = 1
        components.second = -1
        
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    public var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: startOfDay))!
    }
    
    public var endOfMonth: Date {
        var components = DateComponents()
        
        components.month = 1
        components.second = -1
        
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

extension Date {
    public var yearsFromNow: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    public var monthsFromNow: Int {
        Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
    }
    
    public var weeksFromNow: Int {
        Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
    }
    
    public var daysFromNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
    
    public var hoursFromNow: Int {
        Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
    }
    
    public var minutesFromNow: Int {
        Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
    }
    
    public var secondsFromNow: Int {
        Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
    }
    
    public func seconds(from other: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: other, to: self).second ?? 0
    }
    
    public var relativeTime: String? {
        if yearsFromNow > 0 {
            return "\(yearsFromNow) year" + (yearsFromNow    > 1 ? "s" : "") + " ago"
        }
        
        if monthsFromNow > 0 {
            return "\(monthsFromNow) month" + (monthsFromNow   > 1 ? "s" : "") + " ago"
        }
        
        if weeksFromNow > 0 {
            return "\(weeksFromNow) week" + (weeksFromNow    > 1 ? "s" : "") + " ago"
        }
        
        if daysFromNow > 0 {
            return daysFromNow == 1 ? "Yesterday" : "\(daysFromNow) days ago"
        }
        
        if hoursFromNow > 0 {
            return "\(hoursFromNow) hour" + (hoursFromNow > 1 ? "s" : "") + " ago"
        }
        
        if minutesFromNow > 0 {
            return "\(minutesFromNow) minute" + (minutesFromNow > 1 ? "s" : "") + " ago"
        }
        
        if secondsFromNow > 0 {
            return secondsFromNow < 15
                ? "Just now"
                : "\(secondsFromNow) second" + (secondsFromNow > 1 ? "s" : "") + " ago"
        }
        
        return nil
    }
}
