import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch statuses and order-tags from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchStatuses() async throws {
    let client = try makeClient()
    let list = try await Status.list(client: client)
    print("Statuses count: \(list.count)")
    for status in list.list {
        print(" * #\(status.statusId) \(status.name() ?? "") type:\(String(describing: status.type)) active:\(String(describing: status.active)) default:\(String(describing: status.default))")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchOrderTags() async throws {
    let client = try makeClient()
    let list = try await OrderTag.list(client: client)
    print("OrderTags count: \(list.count)")
    for tag in list.list {
        print(" * #\(tag.tagId) \(tag.name) langId:\(tag.langId)")
    }
}
