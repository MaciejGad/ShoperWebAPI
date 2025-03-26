import Testing
import Foundation

@testable import ShoperWebAPI

@Test func testFetchAccessToken() async throws {
    let client = makeClient()
    let accessToken = try await client.getAccessToken()
    print(accessToken)
}

@Test func testFetchProducts() async throws {
    let client = makeClient()
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
    let client = makeClient()
    let product = try await Product.read(client: client, id: 36)
    print("----------------")
    print(product)
}

@Test func testFetchProductImages() async throws {
    let client = makeClient()
    let imageList = try await ProductImage.list(client: client, filters: [
        .productId(36)
    ])
    let images = imageList.list
    print(imageList.count)
    for image in images {
        print(" * \(image)")
    }
}

@Test func testFetchOneImage() async throws {
    let client = makeClient()
    let image = try await ProductImage.read(client: client, id: 183)
    print(image)
}

@Test func testCreateImage() async throws {
    let client = makeClient()
    let imageId = try await ProductImage.create(client: client, payload: ProductImage.CreatePayload.image(url: "https://maciejgad.pl/okulary.jpg", productId: 36, name: "okulary.jpg"))
    print(imageId)
}
    
@Test func testCreateFromLocalImage() async throws {
    let filepath = try #require(Bundle.module.path(forResource: "mock_image", ofType: "jpg"))
    let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
    let client = makeClient()
    let imageId = try await ProductImage.create(client: client, payload: ProductImage.CreatePayload.image(content: data, productId: 36, name: "mock_image.jpg"))
    print(imageId)
}
