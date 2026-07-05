import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// Auction resources (marketplace/auction-house integration) against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars). Responses are saved as new mocks via MOCK_PATH for
// future offline test runs.

@Test func testFetchAuctionHouses() async throws {
    let client = try makeClient()
    let houses = try await AuctionHouse.list(client: client)
    print("AuctionHouses count: \(houses.count)")
    for house in houses.list.prefix(5) {
        print(" * #\(house.auctionHouseId) \(house.name ?? "") engine:\(house.engine ?? "")")
    }
}

@Test func testCreateAuctionHouseRoundTrip() async throws {
    let client = try makeClient()
    let uniqueName = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))"
    let houseId = try await AuctionHouse.create(client: client, payload: CreateAuctionHouse(name: uniqueName))
    print("Created auction house id: \(houseId)")

    let fetched = try await AuctionHouse.get(client: client, id: houseId)
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await AuctionHouse.delete(client: client, id: houseId)
    print("Deleted: \(deleted)")
}

@Test func testFetchAuctions() async throws {
    let client = try makeClient()
    let auctions = try await Auction.list(client: client)
    print("Auctions count: \(auctions.count)")
    for auction in auctions.list.prefix(5) {
        print(" * #\(auction.auctionId) \(auction.title ?? "") product:\(String(describing: auction.productId))")
    }
}

@Test func testCreateAuctionRoundTrip() async throws {
    let client = try makeClient()
    let products = try await Product.list(client: client)
    guard let productId = products.list.first?.productId else {
        print("No products on this store — skipping.")
        return
    }
    let houseId = try await AuctionHouse.create(client: client, payload: CreateAuctionHouse(name: "shoperwebapi-test-house-\(Int(Date().timeIntervalSince1970))"))

    let uniqueRealId = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))"
    let payload = CreateAuction(
        auctionHouseId: houseId,
        realAuctionId: uniqueRealId,
        title: "shoperwebapi-test auction",
        salesFormat: 1,
        productId: productId,
        quantity: 1
    )
    let auctionId = try await Auction.create(client: client, payload: payload)
    print("Created auction id: \(auctionId)")

    let fetched = try await Auction.get(client: client, id: auctionId)
    #expect(fetched.realAuctionId?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await Auction.delete(client: client, id: auctionId)
    print("Deleted: \(deleted)")

    let houseDeleted = try await AuctionHouse.delete(client: client, id: houseId)
    print("Deleted auction house: \(houseDeleted)")
}

@Test func testFetchAuctionOrders() async throws {
    let client = try makeClient()
    let orders = try await AuctionOrder.list(client: client)
    print("AuctionOrders count: \(orders.count)")
    for order in orders.list.prefix(5) {
        print(" * #\(order.auctionOrderId) orderId:\(String(describing: order.orderId)) buyer:\(order.buyerLogin ?? "")")
    }
}

@Test func testCreateAuctionOrderRoundTrip() async throws {
    let client = try makeClient()
    let shopOrders = try await ShopOrder.list(client: client)
    guard let orderId = shopOrders.list.first?.orderId else {
        print("No orders on this store — skipping.")
        return
    }
    let payload = CreateAuctionOrder(orderId: orderId, buyerLogin: "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))")
    let auctionOrderId = try await AuctionOrder.create(client: client, payload: payload)
    print("Created auction order id: \(auctionOrderId)")

    let fetched = try await AuctionOrder.get(client: client, id: auctionOrderId)
    #expect(fetched.buyerLogin?.hasPrefix("shoperwebapi-test-") == true)

    // No DELETE endpoint exists for auction-orders (see AuctionOrder.swift doc comment) — leaving
    // this test-created record in place rather than calling `.delete()`, which would 404.
}
