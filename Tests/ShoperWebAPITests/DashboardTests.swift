import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch dashboard activities/stats from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs. Both are read-only.

@Test func testFetchDashboardActivities() async throws {
    let client = try makeClient()
    let activities = try await DashboardActivity.list(client: client)
    print("DashboardActivities count: \(activities.count)")
    for activity in activities.prefix(5) {
        print(" * #\(activity.id) [\(activity.object ?? "")] \(activity.info ?? "") time:\(String(describing: activity.time))")
    }
}

@Test func testFetchDashboardStats() async throws {
    let client = try makeClient()
    let stats = try await DashboardStat.get(client: client)
    print("today: \(String(describing: stats.today))")
    print("last7Days: \(String(describing: stats.last7Days))")
    print("last30Days: \(String(describing: stats.last30Days))")
    print("general: \(String(describing: stats.general))")
    #expect(stats.general != nil)
}
