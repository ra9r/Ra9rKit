//
//  RelativeMonthFormatterTest.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/5/24.
//

import XCTest
@testable import Ra9rCore

final class RelativeMonthFormatterTests: XCTestCase {

    var formatter: RelativeMonthFormatter!
    let calendar = Calendar.current
    
    override func setUp() {
        super.setUp()
        formatter = RelativeMonthFormatter()
    }
    
    override func tearDown() {
        formatter = nil
        super.tearDown()
    }
    
    func testCurrentMonth() {
        let currentDate = Date()
        XCTAssertEqual(formatter.string(for: currentDate), "This Month")
    }
    
    func testLastMonth() {
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: Date())
        XCTAssertEqual(formatter.string(for: lastMonthDate), "Last Month")
    }
    
    func testOtherMonth() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let pastDate = calendar.date(byAdding: .month, value: -2, to: Date())!
        let expectedFormat = dateFormatter.string(from: pastDate)
        
        XCTAssertEqual(formatter.string(for: pastDate), expectedFormat)
    }

}
