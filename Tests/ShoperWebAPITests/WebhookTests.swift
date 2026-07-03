import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests exercise webhooks against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding and the create/delete payload.
// Responses are saved as new mocks via MOCK_PATH for future offline test runs.

@Test func testFetchWebhooks() async throws {
    let client = try makeClient()
    let list = try await Webhook.list(client: client)
    print("Webhooks count: \(list.count)")
    for webhook in list.list {
        print(" * #\(webhook.webhookId) \(webhook.url ?? "") format:\(String(describing: webhook.format)) active:\(String(describing: webhook.active)) events:\(webhook.events ?? [])")
    }
}

// This test store is a sandbox, so it's safe to mutate: it creates a real webhook, verifies it
// via get, then deletes it to clean up after itself.
@Test func testCreateAndDeleteWebhookRoundTrip() async throws {
    let client = try makeClient()
    let payload = CreateWebhook(
        url: "https://example.com/shoperwebapi-test-webhook",
        format: .json,
        active: false,
        events: [.orderCreate]
    )
    let webhookId = try await Webhook.create(client: client, payload: payload)
    print("Created webhook id: \(webhookId)")
    #expect(webhookId > 0)

    let fetched = try await Webhook.get(client: client, id: webhookId)
    print(fetched)
    #expect(fetched.webhookId == webhookId)
    #expect(fetched.url == "https://example.com/shoperwebapi-test-webhook")
    #expect(fetched.format == .json)
    #expect(fetched.events == [.orderCreate])

    let deleted = try await Webhook.delete(client: client, id: webhookId)
    print("Delete result: \(deleted)")
    #expect(deleted == true)
}

@Test func testWebhookEventDecodesUnknownValue() throws {
    let event = try JSONDecoder().decode(WebhookEvent.self, from: Data("\"admin.account_connected\"".utf8))
    #expect(event == .unknown("admin.account_connected"))
    #expect(event.rawValue == "admin.account_connected")
}

@Test func testWebhookEventEncodesAsString() throws {
    let payload = CreateWebhook(url: "https://example.com/hook", format: .json, events: [.productCreate, .productDelete])
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(payload)
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    #expect(json["events"] as? [String] == ["product.create", "product.delete"])
}
