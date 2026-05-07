import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

@Test func testSort() async throws {
    let client = try makeClient()
    let productList = try await Product.list(client: client, sort: [
        .name(direction: .ascending)
    ])
    let products = productList.list
    print(productList.count)
    // in mocks data isn't sorted but
    // the url should be correct
    // if data is loaded
    for product in products {
        let plTranslation = try #require(product.translations["pl_PL"])
        let mainImage = try #require(product.mainImage)
        print("\(product.id) \(plTranslation.name): \(product.stock.stock) \(mainImage)")
    }
}

@Test func testLimit() async throws {
    let client = try makeClient()
    let productList = try await Product.list(client: client, filters: [], sort: [], page: nil, limit: 3)
    let products = productList.list
    #expect(products.count == 3)
}

@Test func testFetchOrderProducts() async throws {
    let client = try makeClient()
    let list = try await OrderProduct.list(client: client)
    #expect(list.count == 3)
    #expect(list.page == 1)
    let items = list.list
    #expect(items.count == 3)
    for item in items {
        print("\(item.id) order:\(item.orderId ?? -1) product:\(item.productId ?? -1) \(item.name ?? "") qty:\(item.quantity ?? 0)")
    }
}

@Test func testFetchOneOrderProduct() async throws {
    let client = try makeClient()
    let item = try await OrderProduct.get(client: client, id: 1)
    #expect(item.orderProductId == 1)
    #expect(item.orderId == 100)
    #expect(item.productId == 36)
    #expect(item.name == "Okulary słoneczne Orange")
    print(item)
}

@Test func testFetchOrderProductsByOrderId() async throws {
    let client = try makeClient()
    let list = try await OrderProduct.list(client: client, filters: [
        .orderId(100)
    ])
    #expect(list.count == 2)
    let items = list.list
    #expect(items.count == 2)
    for item in items {
        let orderId = try #require(item.orderId)
        #expect(orderId == 100)
    }
}

@Test func testOrderProductsPageTwo() async throws {
    let client = try makeClient()
    let list = try await OrderProduct.list(client: client, page: 2)
    #expect(list.page == 2)
    #expect(list.count == 15)
    #expect(list.pages == 2)
    #expect(list.list.count == 2)
}

@Test func testOrderProductsLimit() async throws {
    let client = try makeClient()
    let list = try await OrderProduct.list(client: client, filters: [], sort: [], page: nil, limit: 3)
    #expect(list.list.count == 3)
}

@Test func testOrderProductsSortByPrice() async throws {
    let client = try makeClient()
    let list = try await OrderProduct.list(client: client, sort: [
        .price(direction: .descending)
    ])
    let items = list.list
    print("Order products sorted by price desc:")
    for item in items {
        print(" * \(item.name ?? "") price:\(item.price ?? 0)")
    }
}


@Test func testFetchOrders() async throws {
    let client = try makeClient()
    let list = try await ShopOrder.list(client: client)
    #expect(list.count == 1)
    #expect(list.page == 1)
    #expect(list.list.count == 1)

    let order = try #require(list.list.first)
    #expect(order.orderId == 100)
    #expect(order.email == "jan.kowalski@example.pl")
    #expect(order.deliveryAddress?.city == "Warszawa")

    let deliveryDate = try #require(order.deliveryDate)
    let shippingCost = try #require(order.shippingCost)
    let pickupPointData = try #require(order.pickupPointData)

    #expect(!String(describing: deliveryDate).isEmpty)
    #expect(shippingCost >= 0)
    #expect(!String(describing: pickupPointData).isEmpty)

    print("\(order.id) email:\(order.email ?? "") sum:\(order.sum ?? 0)")
}

@Test func testFetchOneOrder() async throws {
    let client = try makeClient()
    let order = try await ShopOrder.get(client: client, id: 100)
    #expect(order.orderId == 100)
    #expect(order.userId == 5)
    #expect(order.email == "jan.kowalski@example.pl")
    #expect(order.paid == Decimal(1))
    let sum = try #require(order.sum)
    #expect(order.deliveryAddress?.city == "Warszawa")
    #expect(sum == Decimal(sign: .plus, exponent: -2, significand: 58000))
    print(order)
}

@Test func testFetchOrdersByStatusId() async throws {
    let client = try makeClient()
    let list = try await ShopOrder.list(client: client, filters: [
        .statusId(2)
    ])
    #expect(list.count == 1)
    let items = list.list
    #expect(items.count == 1)
    let statusId = try #require(items.first?.statusId)
    #expect(statusId == 2)
}

@Test func testFetchUnpaidOrders() async throws {
    let client = try makeClient()
    let list = try await ShopOrder.list(client: client, filters: [
        .paid(false)
    ])
    #expect(list.count == 2)
    for order in list.list {
        #expect(order.paid == 0)
    }
}

@Test func testOrdersPageTwo() async throws {
    let client = try makeClient()
    let list = try await ShopOrder.list(client: client, page: 2)
    #expect(list.page == 2)
    #expect(list.count == 15)
    #expect(list.pages == 2)
    #expect(list.list.count == 2)
}

@Test func testOrdersLimit() async throws {
    let client = try makeClient()
    let list = try await ShopOrder.list(client: client, filters: [], sort: [], page: nil, limit: 2)
    #expect(list.list.count == 2)
}

@Test func testOrdersSortByDateDesc() async throws {
    let client = try makeClient()
    let list = try await ShopOrder.list(client: client, sort: [
        .date(direction: .descending)
    ])
    let orders = list.list
    print("Orders sorted by date desc:")
    for order in orders {
        print(" * \(order.id) \(order.date ?? "") \(order.email ?? "")")
    }
    #expect(orders.count == 3)
}