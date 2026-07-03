import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch shop metadata (version, config, lock status, progresses) from a live Shoper
// store (see SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved
// as new mocks via MOCK_PATH for future offline test runs. All read-only — see ApplicationLock's
// doc comment for why engaging the lock is intentionally not exercised here.

@Test func testFetchApplicationVersion() async throws {
    let client = try makeClient()
    let version = try await ApplicationVersion.get(client: client)
    print("Application version: \(version.version)")
    #expect(!version.version.isEmpty)
}

@Test func testFetchApplicationConfig() async throws {
    let client = try makeClient()
    let config = try await ApplicationConfig.get(client: client)
    print("shopName:\(config.shopName ?? "") shopUrl:\(config.shopUrl ?? "") defaultCurrency:\(config.defaultCurrencyName ?? "") defaultLanguage:\(config.defaultLanguageName ?? "") warehousesEnabled:\(String(describing: config.warehousesEnabled)) storefrontEnabled:\(String(describing: config.storefrontEnabled))")
    #expect(config.shopUrl != nil)
}

@Test func testFetchApplicationLock() async throws {
    let client = try makeClient()
    let lock = try await ApplicationLock.get(client: client)
    print("locked:\(String(describing: lock.locked)) message:\(lock.message ?? "") userId:\(String(describing: lock.userId))")
}

@Test func testFetchProgresses() async throws {
    let client = try makeClient()
    let list = try await Progress.list(client: client)
    print("Progresses count: \(list.count)")
    for progress in list.list {
        print(" * #\(progress.progressId) \(progress.name ?? "") status:\(String(describing: progress.status)) \(String(describing: progress.nominator))/\(String(describing: progress.denominator))")
    }
}
