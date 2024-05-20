//
//  DateExtensionTests.swift
//  
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import XCTest
@testable import Ra9rCore

class DateExtensionTests: XCTestCase {
    
    var calendar: Calendar!
    
    override func setUp() {
        super.setUp()
        calendar = Calendar.current
    }
    
    override func tearDown() {
        calendar = nil
        super.tearDown()
    }
    
    func testStartOfDay() {
        // Given
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 1974, month: 10, day: 4, hour: 13, minute: 30, second: 0))!
        let expectedStartOfDay = calendar.date(from: DateComponents(year: 1974, month: 10, day: 4, hour: 0, minute: 0, second: 0))!
        
        // When
        let startOfDay = date.startOfDay
        
        // Then
        XCTAssertEqual(startOfDay, expectedStartOfDay, "The start of the day should be the same")
    }
    
    func testEndOfDay() {
        // Given
        // Given
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 1974, month: 10, day: 4, hour: 13, minute: 30, second: 0))!
        let expectedEndOfDay = calendar.date(from: DateComponents(year: 1974, month: 10, day: 4, hour: 23, minute: 59, second: 59))!
        
        // When
        let endOfDay = date.endOfDay
        
        // Then
        XCTAssertEqual(endOfDay, expectedEndOfDay, "The end of the day should be the same")
    }
    
    func testFormat() {
        let date = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let formattedDate = date.formatted("yyyy-MM-dd")
        XCTAssertEqual(formattedDate, "1970-01-01")
    }
    
    func testSameAs() {
        let date1 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let date2 = Date(timeIntervalSince1970: 86400) // 2nd Jan 1970
        XCTAssertFalse(date1.sameAs(date2))
        
        let date3 = Date(timeIntervalSince1970: 0) // Also 1st Jan 1970
        XCTAssertTrue(date1.sameAs(date3))
    }
    
    func testAddIntervalWeeks() {
        // Test case 1: Adding one week
        let startDate1 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let expectedDate1 = calendar.date(byAdding: .day, value: 7, to: startDate1)!
        let newDate1 = startDate1.addInterval(weeks: 1)
        XCTAssertEqual(newDate1, expectedDate1)
        
        // Test case 2: Adding multiple weeks
        let startDate2 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let expectedDate2 = calendar.date(byAdding: .day, value: 21, to: startDate2)! // 3 weeks
        let newDate2 = startDate2.addInterval(weeks: 3)
        XCTAssertEqual(newDate2, expectedDate2)
    }
    
    func testAddIntervalDays() {
        // Test case 1: Adding a single day
        let startDate1 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let expectedDate1 = calendar.date(byAdding: .day, value: 1, to: startDate1)!
        let newDate1 = startDate1.addInterval(days: 1)
        XCTAssertEqual(newDate1, expectedDate1)
        
        // Test case 2: Adding multiple days
        let startDate2 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let expectedDate2 = calendar.date(byAdding: .day, value: 10, to: startDate2)! // 10 days
        let newDate2 = startDate2.addInterval(days: 10)
        XCTAssertEqual(newDate2, expectedDate2)
    }
    
    func testAddIntervalHours() {
        // Test case 1: Adding a single hour
        let startDate1 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let expectedDate1 = calendar.date(byAdding: .hour, value: 1, to: startDate1)!
        let newDate1 = startDate1.addInterval(hours: 1)
        XCTAssertEqual(newDate1, expectedDate1)
        
        // Test case 2: Adding multiple hours
        let startDate2 = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let expectedDate2 = calendar.date(byAdding: .hour, value: 24, to: startDate2)! // 24 hours (1 day)
        let newDate2 = startDate2.addInterval(hours: 24)
        XCTAssertEqual(newDate2, expectedDate2)
    }
    
    func testIsBetween() {
        let startDate = Date(timeIntervalSince1970: 0) // 1st Jan 1970
        let endDate = Date(timeIntervalSince1970: 86400 * 2) // 3rd Jan 1970
        let middleDate = Date(timeIntervalSince1970: 86400) // 2nd Jan 1970
        
        XCTAssertTrue(middleDate.isBetween(startDate, and: endDate))
        XCTAssertFalse(startDate.isBetween(middleDate, and: endDate))
    }
    
    func testRelative() {
        let now = Date()
        // Test case 1: Yesterday relative to now
        let yesterday = calendar.date(byAdding: .second, value: -20, to: now)!
        let relativeDescriptionYesterday = yesterday.relative(to: now)
        XCTAssertEqual(relativeDescriptionYesterday, "1 hour ago")
        
        // Test case 2: Tomorrow relative to now
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
        let relativeDescriptionTomorrow = tomorrow.relative(to: now)
        XCTAssertEqual(relativeDescriptionTomorrow, "in 23 hours")
        
        // Test case 3: Now relative to now
        let relativeDescriptionNow = now.relative(to: now)
        XCTAssertEqual(relativeDescriptionNow, "Today")
    }
}
