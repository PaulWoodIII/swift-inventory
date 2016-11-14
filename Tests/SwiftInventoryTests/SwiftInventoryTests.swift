import XCTest
@testable import SwiftInventory

class SwiftInventoryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Inventory().text, "Hello, World!")
    }


    static var allTests : [(String, (SwiftInventoryTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
