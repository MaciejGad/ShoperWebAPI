import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

private func encodeToJSON(_ value: some Encodable) throws -> [String: Any] {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(value)
    let object = try JSONSerialization.jsonObject(with: data)
    return try #require(object as? [String: Any])
}

// MARK: - ProductStockPayload encoding
// Unlike CreateProductStock (nested inside ProductInsert), the standalone /product-stocks
// endpoint allows writing active/code/default/ean/weight_type directly.

@Test func testProductStockPayloadEncodesWritableFields() throws {
    let payload = ProductStockPayload(
        productId: 36,
        active: true,
        code: "TEST-STOCK-001",
        default: true,
        ean: "1234567890123",
        price: 99.90,
        stock: 5,
        weightType: 1
    )
    let json = try encodeToJSON(payload)

    #expect(json["product_id"] as? Int == 36)
    #expect(json["active"] as? Bool == true)
    #expect(json["code"] as? String == "TEST-STOCK-001")
    #expect(json["default"] as? Bool == true)
    #expect(json["ean"] as? String == "1234567890123")
    #expect(json["weight_type"] as? Int == 1)

    // Fields not set should be omitted
    #expect(json["gfx_id"] == nil)
    #expect(json["warehouses"] == nil)
}

// This test fetches product-stocks from a live Shoper store (see SHOPER_DOMAIN/USERNAME/PASSWORD
// env vars) to validate ProductStock decoding. The response is saved as a new mock via MOCK_PATH
// for future offline test runs.
@Test func testFetchProductStocks() async throws {
    let client = try makeClient()
    let list = try await ProductStock.list(client: client, filters: [], sort: [], page: nil, limit: 5)
    print("count: \(list.count) page: \(list.page) pages: \(list.pages)")
    for stock in list.list {
        print(" * stockId:\(stock.stockId) productId:\(stock.productId) code:\(stock.code) price:\(stock.price) stock:\(stock.stock) active:\(stock.active) default:\(stock.default)")
    }
    #expect(!list.list.isEmpty)
    let first = try #require(list.list.first)
    #expect(first.stockId > 0)
    #expect(first.productId > 0)
}

@Test func testFetchOneProductStock() async throws {
    let client = try makeClient()
    let list = try await ProductStock.list(client: client, filters: [], sort: [], page: nil, limit: 1)
    let firstId = try #require(list.list.first?.stockId)
    let stock = try await ProductStock.get(client: client, id: firstId)
    print(stock)
    #expect(stock.stockId == firstId)
}
