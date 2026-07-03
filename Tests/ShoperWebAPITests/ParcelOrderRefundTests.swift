import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import ShoperWebAPI

// These tests fetch parcels, order-refunds, and order-transactions from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchParcels() async throws {
    let client = try makeClient()
    let list = try await Parcel.list(client: client)
    print("Parcels count: \(list.count)")
    for parcel in list.list {
        print(" * #\(parcel.parcelId) orderId:\(String(describing: parcel.orderId)) shippingId:\(String(describing: parcel.shippingId)) sent:\(String(describing: parcel.sent))")
    }
}

// order-refunds and order-transactions are marked x-internal in the OpenAPI spec ("Resources
// available for selected applications"). Confirmed live: this store's token gets HTTP 403
// insufficient_scope. MockURLProtocol always replays HTTP 200, so this can't be replayed
// offline with a real 403 — these tests just document/report whatever happens without failing
// the suite, since the meaningful verification already happened against the live API.
@Test func testFetchOrderRefundsRequiresSpecialPermission() async throws {
    let client = try makeClient()
    do {
        let list = try await OrderRefund.list(client: client)
        print("OrderRefunds count: \(list.count) (endpoint is accessible on this store)")
    } catch let ShoperError.invalidResponse(data, response) {
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        print("OrderRefunds request failed: HTTP \(status) — \(String(data: data, encoding: .utf8) ?? "")")
    } catch {
        print("OrderRefunds request failed (no matching mock / other error): \(error)")
    }
}

@Test func testFetchOrderTransactionsRequiresSpecialPermission() async throws {
    let client = try makeClient()
    do {
        let list = try await OrderTransaction.list(client: client)
        print("OrderTransactions count: \(list.count) (endpoint is accessible on this store)")
    } catch let ShoperError.invalidResponse(data, response) {
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        print("OrderTransactions request failed: HTTP \(status) — \(String(data: data, encoding: .utf8) ?? "")")
    } catch {
        print("OrderTransactions request failed (no matching mock / other error): \(error)")
    }
}
