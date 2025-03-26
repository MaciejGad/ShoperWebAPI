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
    let productList = try await Product.list(client: client, filters: [
        .name("okulary"),
        .stock(greaterThan: 0)
    ])
    let products = productList.list
    print(productList.count)
    for product in products {
        let plTranslation = try #require(product.translations["pl_PL"])
        let mainImage = try #require(product.mainImage)
        print("\(product.id) \(plTranslation.name): \(product.stock.stock) \(mainImage)")
    }
}

@Test func testFetchOneProduct() async throws {
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: true)
    let client = Client(config: config)
    let product = try await Product.read(client: client, id: 36)
    print("----------------")
    print(product)
}

@Test func testFetchProductImages() async throws {
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: true)
    let client = Client(config: config)
    let imageList = try await ProductImage.list(client: client, filters: [
//        .init(key: .parameter(.productId), value: .equal("36"))
        .init(key: .parameter(.productId), value: .equal("36"))
    ])
    let images = imageList.list
    print(imageList.count)
    for image in images {
        print(" * \(image)")
    }
}

@Test func testFetchOneImage() async throws {
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: true)
    let client = Client(config: config)
    let image = try await ProductImage.read(client: client, id: 31)
    print(image)
}

@Test func testCreateImage() async throws {
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: true)
    let client = Client(config: config)
    let imageId = try await ProductImage.create(client: client, payload: ProductImage.CreatePayload.image(url: "https://maciejgad.pl/okulary.jpg", productId: 36, name: "okulary.jpg"))
    print(imageId)
}
    
@Test func testCreateFromLocalImage() async throws {
    let url = try #require(URL(string: "https://maciejgad.pl/okulary2.jpg"))
    let file = try Data(contentsOf: url)
    let config = Config(shopURL: Environment.shopURL, login: Environment.username, password: Environment.password, verbose: true)
    let client = Client(config: config)
    let imageId = try await ProductImage.create(client: client, payload: ProductImage.CreatePayload.image(content: file, productId: 36, name: "okulary2.jpg"))
    print(imageId)
}
