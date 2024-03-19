//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/16/24.
//

import XCTest
@testable import Ra9rCore // Replace 'YourProjectName' with your project's name

class DoubleExtensionTests: XCTestCase {
    
    // MARK: - formatPrecision(decimals:) Tests
    func testFormatPrecisionWithZeroDecimals() {
        let value = 3.14159
        XCTAssertEqual(value.formatPrecision(0), "3")
    }
    
    func testFormatPrecisionWithTwoDecimals() {
        let value = 12.345
        XCTAssertEqual(value.formatPrecision(2), "12.35")
    }
    
    func testFormatPrecisionWithLargeNumberOfDecimals() {
        let value = 0.000001234
        XCTAssertEqual(value.formatPrecision(8), "0.00000123")
    }
    
    // MARK: - uncombine() Tests
    func testUncombineWholeNumber() {
        let value = 5.0
        let expectedResult = (wholeNumber: 5, decimalNumber: 0)
        let actualResult = value.uncombine()
        XCTAssertEqual(actualResult.wholeNumber, expectedResult.wholeNumber)
        XCTAssertEqual(actualResult.decimalNumber, expectedResult.decimalNumber)
    }
    
    func testUncombineDecimalNumber() {
        let value = 3.75
        let expectedResult = (wholeNumber: 3, decimalNumber: 7)
        let actualResult = value.uncombine()
        XCTAssertEqual(actualResult.wholeNumber, expectedResult.wholeNumber)
        XCTAssertEqual(actualResult.decimalNumber, expectedResult.decimalNumber)
    }
    
    // MARK: - Double Initializer Tests
    func testInitializerWithWholeAndDecimal() {
        let wholeNumber = 12
        let decimalNumber = 4
        let expectedResult = 12.4
        XCTAssertEqual(Double(wholeNumber, decimalNumber), expectedResult)
    }
    
    // MARK: - formatInches() Tests
    func testFormatInchesWholeNumber() {
        var value = 6.0
        XCTAssertEqual(value.formatInches(), "6.0")
    }
    
    func testFormatInchesWithOneSixteenth() {
        var value = 6.0 + (1/16)
        XCTAssertEqual(value.formatInches(), "6 ¹⁄₁₆")
    }
    
    func testFormatInchesWith3Sixteenth() {
        var value = 6.0 + (3/16)
        XCTAssertEqual(value.formatInches(), "6 ³⁄₁₆")
    }
    
    func testFormatInchesWith1Third() {
        var value = 6.0 + (1/3)
        XCTAssertEqual(value.formatInches(), "6 ⅓")
    }
    
    func testFormatInchesWith1Sixteenth() {
        var value = 1.0 + (1.0/16.0)
        XCTAssertEqual(value.formatInches(), "1 ¹⁄₁₆")
    }
    
    func testFormatInchesWith15Sixteenth() {
        var value = 6.0 + (15/16)
        XCTAssertEqual(value.formatInches(), "6 ¹⁵⁄₁₆")
    }
    
    func testFormatInchesHalfInch() {
        var value = 2.5
        XCTAssertEqual(value.formatInches(), "2 ½")
    }
    
    func testFormatInchesQuarterInch() {
        var value = 3.25
        XCTAssertEqual(value.formatInches(), "3 ¼")
    }
    
    func testFormatInchesWithApproximations() {
        var value = 4.13  // Close to 1/8
        XCTAssertEqual(value.formatInches(), "4.1")
    }
}

