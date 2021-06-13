//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension Date {
    public init(string: String, dateFormat: String) throws {
        let formatter = DateFormatter()
        
        formatter.dateFormat = dateFormat
        
        self = try formatter.date(from: string).unwrap()
    }
    
    /// Convert this date to a `String` given a certain format.
    public func toString(dateFormat format: String) -> String {
        DateFormatter()
            .then({ $0.dateFormat = format })
            .string(from: self)
    }
    
    /// Convert this date to a `String` given a certain format.
    public func toString(
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style
    ) -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        
        return formatter.string(from: self)
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
    
    public func adding(days: Int) -> Date! {
        Calendar.current.date(byAdding: DateComponents(day: days), to: Date())
    }
    
    /// Number of days (relative to this date) till a given date.
    public func days(till other: Date, in calendar: Calendar = .current) -> Int! {
        calendar.dateComponents([.day], from: self, to: other).day
    }
    
    public func seconds(from other: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: other, to: self).second ?? 0
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
}

extension Date {
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
