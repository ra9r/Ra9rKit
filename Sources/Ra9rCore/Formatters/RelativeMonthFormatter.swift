//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/5/24.
//

import Foundation

public class RelativeMonthFormatter: Formatter {
    private let calendar = Calendar.current
    
    public override func string(for obj: Any?) -> String? {
        guard let date = obj as? Date else { return nil }
        
        // Get the current date components
        let nowComponents = calendar.dateComponents([.year, .month], from: Date())
        // Get the date components for the passed date
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        
        switch (dateComponents.year, dateComponents.month, nowComponents.year, nowComponents.month) {
            case (let year?, let month?, let currentYear?, let currentMonth?) where year == currentYear && month == currentMonth:
                return "This Month"
            case (let year?, let month?, let currentYear?, let currentMonth?) where year == currentYear && month == currentMonth - 1:
                return "Last Month"
            default:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                return dateFormatter.string(from: date)
        }
    }
}
