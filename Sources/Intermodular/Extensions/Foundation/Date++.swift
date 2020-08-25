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
    
    public func get(
        _ components: Calendar.Component...,
        calendar: Calendar = Calendar.current
    ) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    public func get(
        _ component: Calendar.Component,
        calendar: Calendar = Calendar.current
    ) -> Int {
        return calendar.component(component, from: self)
    }
    
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
        Calendar.current.date(from: startOfDay.get(.year, .month))!
    }
    
    public var endOfMonth: Date {
        var components = DateComponents()
        
        components.month = 1
        components.second = -1
        
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

extension Date {
    public var yearsToNow: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    public var monthsToNow: Int {
        Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
    }
    
    public var weeksToNow: Int {
        Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
    }
    
    public var daysToNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
    
    public var hoursToNow: Int {
        Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
    }
    
    public var minutesToNow: Int {
        Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
    }
    
    public var secondsToNow: Int {
        Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
    }
    
    public func seconds(from other: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: other, to: self).second ?? 0
    }
    
    public var relativeTimeDescription: String? {
        if yearsToNow > 0 {
            return "\(yearsToNow) year" + (yearsToNow > 1 ? "s" : "") + " ago"
        }
        
        if monthsToNow > 0 {
            return "\(monthsToNow) month" + (monthsToNow > 1 ? "s" : "") + " ago"
        }
        
        if weeksToNow > 0 {
            return "\(weeksToNow) week" + (weeksToNow > 1 ? "s" : "") + " ago"
        }
        
        if daysToNow > 0 {
            return daysToNow == 1 ? "Yesterday" : "\(daysToNow) days ago"
        }
        
        if hoursToNow > 0 {
            return "\(hoursToNow) hour" + (hoursToNow > 1 ? "s" : "") + " ago"
        }
        
        if minutesToNow > 0 {
            return "\(minutesToNow) minute" + (minutesToNow > 1 ? "s" : "") + " ago"
        }
        
        if secondsToNow > 0 {
            return secondsToNow < 15
                ? "Just now"
                : "\(secondsToNow) second" + (secondsToNow > 1 ? "s" : "") + " ago"
        }
        
        return nil
    }
}
