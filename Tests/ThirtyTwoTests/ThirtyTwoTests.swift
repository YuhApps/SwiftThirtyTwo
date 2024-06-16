import XCTest
@testable import ThirtyTwo

final class ThirtyTwoTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        let orgStr = "node"
        let orgData = orgStr.data(using: .utf8)!
        let encodedString = "NZXWIZI="
        let encodedData = encodedString.data(using: .utf8)!
        XCTAssertTrue(ThirtyTwo.thirtyTwoEncode(orgData) == encodedData)
        XCTAssertTrue(ThirtyTwo.thirtyTwoDecode(encodedData) == orgData)
    }
}
