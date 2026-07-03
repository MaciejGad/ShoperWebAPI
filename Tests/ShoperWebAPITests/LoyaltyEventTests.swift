import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests exercise loyalty-events against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs. This store had the loyalty program disabled
// (ApplicationConfig.loyaltyEnable == false) as of the last check, so failures here may simply
// reflect that rather than a bug.

@Test func testFetchLoyaltyEvents() async throws {
    let client = try makeClient()
    do {
        let list = try await LoyaltyEvent.list(client: client)
        print("LoyaltyEvents count: \(list.count)")
        for event in list.list {
            print(" * #\(event.eventId) userId:\(String(describing: event.userId)) score:\(String(describing: event.score)) sum:\(String(describing: event.sum))")
        }
    } catch {
        print("LoyaltyEvents list failed as observed: \(error)")
    }
}

// Live finding (2026-07-03, sklep173975.shoparena.pl): creating a loyalty event returns HTTP 400
// "Program lojalnościowy jest wyłączony" (loyalty program is disabled) — consistent with
// ApplicationConfig.loyaltyEnable == false on this store. This documents the failure rather than
// asserting success, since it can't be verified working without a store that has loyalty enabled.
@Test func testCreateLoyaltyEvent() async throws {
    let client = try makeClient()
    do {
        let payload = CreateLoyaltyEvent(userId: 1, score: 10, note: "ShoperWebAPI test")
        let eventId = try await LoyaltyEvent.create(client: client, payload: payload)
        print("Created loyalty event id: \(eventId) — this store may now have loyalty enabled.")

        let fetched = try await LoyaltyEvent.get(client: client, id: eventId)
        print(fetched)
    } catch {
        print("LoyaltyEvent create failed as observed: \(error)")
    }
}
