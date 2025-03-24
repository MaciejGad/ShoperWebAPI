import Testing
import Foundation

@testable import ShoperWebAPI

@Test func testFetchAccessToken() async throws {
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password)
    let client = Client(config: config)
    let accessToken = try await client.getAccessToken()
    print(accessToken)
}

@Test func testFetchProducts() async throws {
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: true)
    let client = Client(config: config)
    let products = try await Product.list(client: client).list
    print(products)
}

