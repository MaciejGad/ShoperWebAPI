import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch users, user-addresses, user-groups, user-tags, subscribers, and
// subscriber-groups from a live Shoper store (see SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to
// validate decoding. Responses are saved as new mocks via MOCK_PATH for future offline test runs.

@Test func testFetchUsers() async throws {
    let client = try makeClient()
    let list = try await User.list(client: client)
    print("Users count: \(list.count)")
    for user in list.list {
        print(" * #\(user.userId) \(user.email) \(user.firstname ?? "") \(user.lastname ?? "") active:\(String(describing: user.active)) registered:\(String(describing: user.registered))")
    }
}

@Test func testFetchUserAddresses() async throws {
    let client = try makeClient()
    let list = try await UserAddress.list(client: client)
    print("UserAddresses count: \(list.count)")
    for address in list.list {
        print(" * #\(address.addressBookId) userId:\(address.userId) \(address.firstname) \(address.lastname) \(address.city)")
    }
}

@Test func testFetchUserGroups() async throws {
    let client = try makeClient()
    let list = try await UserGroup.list(client: client)
    print("UserGroups count: \(list.count)")
    for group in list.list {
        print(" * #\(String(describing: group.groupId)) \(group.name) discount:\(String(describing: group.discount))")
    }
}

@Test func testFetchUserTags() async throws {
    let client = try makeClient()
    let list = try await UserTag.list(client: client)
    print("UserTags count: \(list.count)")
    for tag in list.list {
        print(" * #\(tag.tagId) \(tag.name)")
    }
}

@Test func testFetchSubscribers() async throws {
    let client = try makeClient()
    let list = try await Subscriber.list(client: client)
    print("Subscribers count: \(list.count)")
    for subscriber in list.list {
        print(" * #\(subscriber.subscriberId) \(subscriber.email) active:\(String(describing: subscriber.active)) dateAdd:\(subscriber.dateAdd ?? "")")
    }
}

@Test func testFetchSubscriberGroups() async throws {
    let client = try makeClient()
    let list = try await SubscriberGroup.list(client: client)
    print("SubscriberGroups count: \(list.count)")
    for group in list.list {
        print(" * #\(String(describing: group.groupId)) \(group.name)")
    }
}
