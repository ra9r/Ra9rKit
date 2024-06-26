//
//  Date+Extention.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Date {
    /// Returns the date for the first of the month for a given date
    public var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start.startOfDay
    }
    
    /// Returns the last date for the month for a given date
    public var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!.endOfDay
    }
    
    /// Returns the start of day e.g. 00:00:00
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Returns the end of day e.g. 23:59:59
    public var endOfDay: Date {
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        return Calendar.current.date(byAdding: .second, value: -1, to: startOfNextDay ?? self)!
    }
    
    /// Returns that locale appropriate start of week given the date
    public var startOfWeek: Date {
        var calendar = Calendar.current
        
        // Find the start of the week for the given date
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    /// Returns `true` if date is today
    public var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    /// Returns `true` if date is yesterday
    public var isYesterday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self)
    }
    
    public var inFuture: Bool {
        return self.endOfDay > .now.endOfDay
    }
    
    /// Formats the date into a string representation based on the specified format pattern.
    ///
    /// - Parameter pattern: A string representing the date format pattern (e.g., "yyyy-MM-dd").
    /// - Returns: A formatted string representation of the date.
    public func formatted(_ pattern: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        
        return dateFormatter.string(from: self)
    }
    
    /// Compares this date with another date to determine if they represent the same day.
    ///
    /// - Parameter dr: The date to compare with.
    /// - Returns: A Boolean value indicating whether the two dates represent the same day.
    public func sameAs(_ dr: Date) -> Bool {
        return Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: dr) &&
        Calendar.current.component(.month, from: self) == Calendar.current.component(.month, from: dr) &&
        Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: dr)
    }
    
    /// Adds a specified number of weeks to the date.
    ///
    /// - Parameter weeks: The number of weeks to add to the date.
    /// - Returns: A new Date object representing the date after adding the specified number of weeks.
    public func addInterval(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: (weeks * 7)), to: self)!
    }
    
    /// Adds a specified number of days to the date.
    ///
    /// - Parameter days: The number of days to add to the date.
    /// - Returns: A new Date object representing the date after adding the specified number of days.
    public func addInterval(days: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: days), to: self)!
    }
    
    /// Adds a specified number of hours to the date.
    ///
    /// - Parameter hours: The number of hours to add to the date.
    /// - Returns: A new Date object representing the date after adding the specified number of hours.
    public func addInterval(hours: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(hour: hours), to: self)!
    }
    
    /// Determines if the date is between two other dates.
    ///
    /// - Parameters:
    ///   - date1: The first date to compare against.
    ///   - date2: The second date to compare against.
    /// - Returns: A Boolean indicating whether the current date is between `date1` and `date2`.
    public func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    /// Provides a relative description of the current date compared to another date.
    ///
    /// - Parameter date: The date to compare against. Defaults to the current date and time.
    /// - Returns: A string describing the current date relative to the specified date.
    public func relative(to date: Date = .now) -> String {
        if self > date.addInterval(hours: -12) {
            let dateFormatter = RelativeDateTimeFormatter()
            return dateFormatter.localizedString(for: self, relativeTo: Date.now)
        } else {
            let dateFormatter = DateFormatter()
            
            // US English Locale (en_US)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
            return dateFormatter.string(from: self)
        }
    }
    
    /// Returns the number of days in the month of this date
    public var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    /// Returns an array of the dates of the week the date is contained within.
    public var weekDates: [Date] {
        var day = startOfWeek
        // Create an array to hold dates for the whole week
        var week: [Date] = []
        
        // Populate the array with dates from Monday to Sunday
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: day) {
                week.append(date)
            }
        }
        
        return week
    }
    
    /// Returns a version of the date with the hour, minute, and second all set to `0`
    public var normalized: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
