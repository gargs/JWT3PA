import XCTest
@testable import JWT3PA

final class JWT3PATests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JWT3PA().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
