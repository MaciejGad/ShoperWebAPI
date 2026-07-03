import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch shippings, payments, and zones from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchShippings() async throws {
    let client = try makeClient()
    let list = try await Shipping.list(client: client)
    print("Shippings count: \(list.count)")
    for shipping in list.list {
        print(" * #\(shipping.shippingId) \(shipping.name() ?? "") cost:\(String(describing: shipping.cost)) engine:\(shipping.engine ?? "") active:\(String(describing: shipping.active))")
    }
}

@Test func testFetchPayments() async throws {
    let client = try makeClient()
    let list = try await Payment.list(client: client)
    print("Payments count: \(list.count)")
    for payment in list.list {
        print(" * #\(payment.paymentId) name:\(payment.name ?? "") title:\(payment.title() ?? "") minAmount:\(String(describing: payment.minAmount)) maxAmount:\(String(describing: payment.maxAmount))")
    }
}

@Test func testFetchZones() async throws {
    let client = try makeClient()
    let list = try await Zone.list(client: client)
    print("Zones count: \(list.count)")
    for zone in list.list {
        print(" * #\(zone.zoneId) \(zone.name) mode:\(zone.mode) countries:\(String(describing: zone.countries))")
    }
}
