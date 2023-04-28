import XCTest
@testable import InAppChat

final class InAppChatTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
      XCTAssertEqual(InAppChat.shared.isUserLoggedIn, false)
    }
}
