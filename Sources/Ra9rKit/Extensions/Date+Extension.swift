//
//  Date+Extention.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Date {
    public func format(_ pattern: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        
        return dateFormatter.string(from: self)
    }
    
    public func sameAs(_ dr: Date) -> Bool {
        return Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: dr) &&
        Calendar.current.component(.month, from: self) == Calendar.current.component(.month, from: dr) &&
        Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: dr)
    }
    
    public func addInterval(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: (weeks * 7)), to: self)!
    }
    
    public func addInterval(days: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: days), to: self)!
    }
    
    public func addInterval(hours: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(hour: hours), to: self)!
    }
    
    public func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    public func relative(to date:Date = .now) -> String {
        if self > date.addInterval(hours: 12) {
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
