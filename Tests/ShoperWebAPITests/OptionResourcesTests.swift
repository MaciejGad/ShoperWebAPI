import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch option-groups, options, and option-values from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchOptionGroups() async throws {
    let client = try makeClient()
    let list = try await OptionGroup.list(client: client)
    print("OptionGroups count: \(list.count)")
    for group in list.list {
        print(" * #\(String(describing: group.groupId)) \(group.name() ?? "") totalProducts:\(String(describing: group.totalProducts))")
    }
}

@Test func testFetchOptions() async throws {
    let client = try makeClient()
    let list = try await ShoperOption.list(client: client)
    print("Options count: \(list.count)")
    for option in list.list {
        print(" * #\(option.optionId) \(option.name() ?? "") type:\(option.type ?? "") groupId:\(String(describing: option.groupId))")
    }
}

@Test func testFetchOptionValues() async throws {
    let client = try makeClient()
    let list = try await OptionValue.list(client: client)
    print("OptionValues count: \(list.count)")
    for value in list.list {
        print(" * #\(value.ovalueId) optionId:\(value.optionId) value:\(value.value() ?? "") color:\(value.color ?? "")")
    }
}
