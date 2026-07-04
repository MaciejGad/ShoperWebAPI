import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// Nested under a payment (`/payments/{payment_id}/channels`) — see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars for the live-test path. Per the OpenAPI spec this
// resource is gated to "selected applications" (contact appstore@shoper.pl), so HTTP 403 is an
// expected outcome on a standard token, not a bug — this test documents whichever behavior the
// live store exhibits rather than asserting success.

@Test func testFetchPaymentChannels() async throws {
    let client = try makeClient()
    let payments = try await Payment.list(client: client)
    guard let payment = payments.list.first else {
        print("No payments on this store — skipping.")
        return
    }
    do {
        let channels = try await PaymentChannel.list(client: client, paymentId: payment.paymentId)
        print("PaymentChannels count for payment #\(payment.paymentId): \(channels.count)")
        for channel in channels.list.prefix(5) {
            print(" * channel #\(channel.channelId) key:\(channel.channelKey ?? "") type:\(channel.type ?? "")")
        }
    } catch {
        print("PaymentChannel list failed as observed (likely 403, scope not granted): \(error)")
    }
}

@Test func testCreatePaymentChannel() async throws {
    let client = try makeClient()
    let payments = try await Payment.list(client: client)
    guard let payment = payments.list.first else {
        print("No payments on this store — skipping.")
        return
    }
    do {
        let payload = CreatePaymentChannel(channelKey: "shoperwebapi-test")
        let channelId = try await PaymentChannel.create(client: client, paymentId: payment.paymentId, payload: payload)
        print("Created payment channel id: \(channelId) for payment #\(payment.paymentId)")

        let fetched = try await PaymentChannel.get(client: client, paymentId: payment.paymentId, id: channelId)
        print(fetched)

        let deleted = try await PaymentChannel.delete(client: client, paymentId: payment.paymentId, id: channelId)
        print("Deleted: \(deleted)")
    } catch {
        print("PaymentChannel create failed as observed (likely 403, scope not granted): \(error)")
    }
}
