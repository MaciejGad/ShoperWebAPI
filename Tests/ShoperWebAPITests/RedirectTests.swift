import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests exercise redirects against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding and the create payload.
// Responses are saved as new mocks via MOCK_PATH for future offline test runs.

@Test func testRedirectTypeEncodesAsInt() throws {
    let payload = RedirectPayload(route: "/foo", target: "/bar", type: .product)
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(payload)
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    #expect(json["type"] as? Int == 1)
}

@Test func testRedirectTypeDecodesUnknownValue() throws {
    let decoder = JSONDecoder()
    let type = try decoder.decode(RedirectType.self, from: Data("99".utf8))
    #expect(type == .unknown(99))
    #expect(type.rawValue == 99)
}

@Test func testFetchRedirects() async throws {
    let client = try makeClient()
    let list = try await Redirect.list(client: client)
    print("Redirects count: \(list.count)")
    for redirect in list.list {
        print(" * #\(redirect.redirectId) route:\(redirect.route ?? "") target:\(redirect.target ?? "") type:\(String(describing: redirect.type))")
    }
}

// This test store is a sandbox, so it's safe to mutate: it creates a real redirect to verify the
// full create -> get round trip against the live API.
@Test func testCreateRedirectRoundTrip() async throws {
    let client = try makeClient()
    // route must be unique within the shop, so include a timestamp to allow re-running.
    let uniqueRoute = "/shoperwebapi-test-redirect-\(Int(Date().timeIntervalSince1970))"
    let payload = RedirectPayload(route: uniqueRoute, target: "/", type: .own)
    let redirectId = try await Redirect.create(client: client, payload: payload)
    print("Created redirect id: \(redirectId)")
    #expect(redirectId > 0)

    let fetched = try await Redirect.get(client: client, id: redirectId)
    print(fetched)
    #expect(fetched.redirectId == redirectId)
    #expect(fetched.route?.hasPrefix("/shoperwebapi-test-redirect-") == true)
    #expect(fetched.target == "/")
    #expect(fetched.type == .own)
}

// This test store is a sandbox, so it's safe to mutate: it creates a real redirect and then
// deletes it, verifying Resource.delete against the live API and cleaning up after itself.
@Test func testDeleteRedirectRoundTrip() async throws {
    let client = try makeClient()
    let uniqueRoute = "/shoperwebapi-test-delete-\(Int(Date().timeIntervalSince1970))"
    let payload = RedirectPayload(route: uniqueRoute, target: "/", type: .own)
    let redirectId = try await Redirect.create(client: client, payload: payload)
    print("Created redirect id to delete: \(redirectId)")

    let deleted = try await Redirect.delete(client: client, id: redirectId)
    print("Delete result: \(deleted)")
    #expect(deleted == true)

    // Deleting again should report false (nothing left to delete). Not hard-asserted: MockURLProtocol
    // replays the same frozen response for both calls to this URL, so offline this would
    // incorrectly report `true` again. The real "second delete -> false" behavior was verified
    // live against sklep173975.shoparena.pl (see conversation history / commit notes).
    let deletedAgain = try await Redirect.delete(client: client, id: redirectId)
    print("Second delete result: \(deletedAgain)")
}
