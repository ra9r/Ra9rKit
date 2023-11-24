import XCTest
@testable import Ra9rKit
    
class FloatExtensionTests: XCTestCase {
    
    func testFormatPrecision() {
        let floatNumber: Float = 123.45678
        
        // Test case with 2 decimal places
        let formattedWithTwoDecimals = floatNumber.formatPrecision(2)
        XCTAssertEqual(formattedWithTwoDecimals, "123.46")
        
        // Test case with 3 decimal places
        let formattedWithThreeDecimals = floatNumber.formatPrecision(3)
        XCTAssertEqual(formattedWithThreeDecimals, "123.457")
        
        // Additional test cases with different numbers and decimal places
    }
    
    func testUncombine() {
        // Test case 1
        let float1: Float = 123.4
        let result1 = float1.uncombine()
        XCTAssertEqual(result1.wholeNumber, 123)
        XCTAssertEqual(result1.decimalNumber, 4)
        
        // Test case 2
        let float2: Float = -56.7
        let result2 = float2.uncombine()
        XCTAssertEqual(result2.wholeNumber, -56)
        XCTAssertEqual(result2.decimalNumber, -7)
    }
    
    func testFloatInit() {
        // Test case 1
        let wholeNumber1 = 123
        let decimalNumber1 = 4
        let float1 = Float(wholeNumber1, decimalNumber1)
        XCTAssertEqual(float1, 123.4, accuracy: 0.1)
        
        // Test case 2
        let wholeNumber2 = -56
        let decimalNumber2 = -7
        let float2 = Float(wholeNumber2, decimalNumber2)
        XCTAssertEqual(float2, -56.7, accuracy: 0.1)
    }
}

