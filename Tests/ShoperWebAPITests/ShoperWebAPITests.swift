import Testing
import Foundation

import ShoperWebAPI

@Test func testFetchProducts() async throws {
    let client = try makeClient()
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
    let client = try makeClient()
    let product = try await Product.get(client: client, id: 36)
    print("----------------")
    print(product)
}

@Test func testFetchProductImages() async throws {
    let client = try makeClient()
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
    let client = try makeClient()
    let image = try await ProductImage.get(client: client, id: 183)
    print(image)
}

@Test func testCreateImage() async throws {
    let client = try makeClient()
    let imageId = try await ProductImage.create(client: client, payload: ProductImage.CreatePayload.image(url: "https://maciejgad.pl/okulary.jpg", productId: 36, name: "okulary.jpg"))
    print(imageId)
}
    
@Test func testCreateFromLocalImage() async throws {
    let filepath = try #require(Bundle.module.path(forResource: "mock_image", ofType: "jpg"))
    let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
    let client = try makeClient()
    let imageId = try await ProductImage.create(client: client, payload: ProductImage.CreatePayload.image(content: data, productId: 36, name: "mock_image.jpg"))
    print(imageId)
}

@Test func testUpdateProduct() async throws {
    let client = try makeClient()
    let updateProduct = UpdateProduct(stock: .init(stock: 100))
    try await Product.update(client: client, id: 36, payload: updateProduct)
}

@Test func testFetchProductByNameAndUpdateStock() async throws {
    let client = try makeClient()
    let products = try await Product.list(client: client, filters: [.name("okulary")]).list
    let product = try #require(products.first)
    print(product)
    let updateProduct = UpdateProduct(stock: .init(stock: 200))
    let productId = try #require(product.productId)
    try await Product.update(client: client, id: productId, payload: updateProduct)
}
    
@Test func testFetchProductsPageTwo() async throws {
    let client = try makeClient()
    let productList = try await Product.list(client: client, filters: [
        .stock(greaterThan: 0)
    ], page: 2)
    #expect(productList.page == 2)
    #expect(productList.count == 125)
    #expect(productList.pages == 13)
    let products = productList.list
    print(productList.count)
    #expect(products.count == 10)
    for product in products {
        let plTranslation = try #require(product.translations["pl_PL"])
        let mainImage = try #require(product.mainImage)
        print("\(product.id) \(plTranslation.name): \(product.stock.stock) \(mainImage)")
    }
}
