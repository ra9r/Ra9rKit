//
//  CalendarExtentionTests.swift
//  
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import XCTest
@testable import Ra9rCore


class CalendarExtensionTests: XCTestCase {
    
    var calendar: Calendar!
    
    override func setUp() {
        super.setUp()
        calendar = Calendar.current
    }
    
    override func tearDown() {
        calendar = nil
        super.tearDown()
    }
    
    func testDaysBetween() {
        // Test case 1: Non-inclusive
        let startDate1 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let endDate1 = Date(timeIntervalSince1970: 86400 * 2) // 3rd Jan 1970
        XCTAssertEqual(calendar.daysBetween(startDate1, and: endDate1), 2)
        
        // Test case 2: Inclusive
        XCTAssertEqual(calendar.daysBetween(startDate1, and: endDate1, inclusive: true), 3)
        
        // Additional test cases with various dates, including edge cases like same day, leap years, etc.
    }
}

