//
//  Date+Extention.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Date {
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
}
