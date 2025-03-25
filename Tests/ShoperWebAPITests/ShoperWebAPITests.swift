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
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: false)
    let client = Client(config: config)
    let productList = try await Product.list(client: client, filters: [
        .name("malabrigo sock"),
        .stock(greaterThan: 0)
    ])
    let products = productList.list
    print(productList.count)
    for product in products {
        let plTranslation = try #require(product.translations["pl_PL"])
        print("\(plTranslation.name): \(product.stock.stock)")
    }

}

