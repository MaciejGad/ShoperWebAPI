import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch promotion-codes and specialoffers from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchPromotionCodes() async throws {
    let client = try makeClient()
    let list = try await PromotionCode.list(client: client)
    print("PromotionCodes count: \(list.count)")
    for code in list.list {
        print(" * #\(code.codeId) \(code.code) \(code.name) discount:\(String(describing: code.discount)) active:\(String(describing: code.active))")
    }
}

// This test store is a sandbox, so it's safe to mutate: it creates a real promotion code to
// verify the full create -> get round trip against the live API.
@Test func testCreatePromotionCodeRoundTrip() async throws {
    let client = try makeClient()
    // code must be unique within the shop, so include a timestamp to allow re-running.
    let uniqueCode = "SHOPERWEBAPI-TEST-\(Int(Date().timeIntervalSince1970))"
    let payload = CreatePromotionCode(
        name: "ShoperWebAPI P5e round-trip test",
        code: uniqueCode,
        discountType: 1,
        active: true,
        discount: 10
    )
    let codeId = try await PromotionCode.create(client: client, payload: payload)
    print("Created promotion code id: \(codeId)")
    #expect(codeId > 0)

    let fetched = try await PromotionCode.get(client: client, id: codeId)
    print(fetched)
    #expect(fetched.codeId == codeId)
    // Match by prefix rather than exact equality: when re-run offline against a frozen mock,
    // `uniqueCode` (built from the current timestamp) won't equal the value baked into the mock
    // from whichever run originally recorded it.
    #expect(fetched.code.hasPrefix("SHOPERWEBAPI-TEST-"))
    #expect(fetched.name == "ShoperWebAPI P5e round-trip test")
}

@Test func testFetchProductSpecialOffers() async throws {
    let client = try makeClient()
    let list = try await ProductSpecialOffer.list(client: client)
    print("ProductSpecialOffers count: \(list.count)")
    for offer in list.list {
        print(" * #\(offer.promoId) productId:\(offer.productId) discount:\(String(describing: offer.discount)) dateFrom:\(offer.dateFrom ?? "") dateTo:\(offer.dateTo ?? "")")
    }
}
