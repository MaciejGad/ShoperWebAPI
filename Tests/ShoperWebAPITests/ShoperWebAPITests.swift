import Testing
import Foundation

@testable import ShoperWebAPI

@Test func testFetchAccessToken() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password)
    let client = Client(config: config)
    try await client.fetchAccessToken()
    let accessToken = try #require(client.accessToken)
    print(accessToken)
}

