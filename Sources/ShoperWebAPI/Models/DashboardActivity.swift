import Foundation

/// A recent system activity message shown on the shop admin dashboard.
///
/// `GET /dashboard-activities` returns a flat JSON array (no pagination wrapper, no per-item
/// `GET .../{id}`), so this doesn't conform to `Resource` — same shape as `CategoryTreeNode`.
public struct DashboardActivity: Decodable, Sendable {
    public let id: Int
    public let info: String?
    /// The kind of object this activity relates to, e.g. "order" or "client".
    public let object: String?
    /// Event timestamp (Unix epoch seconds).
    public let time: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeInt(forKey: .id)
        self.info = try container.decodeIfPresent(String.self, forKey: .info)
        self.object = try container.decodeIfPresent(String.self, forKey: .object)
        self.time = try container.decodeIntIfPresent(forKey: .time)
    }

    enum CodingKeys: CodingKey {
        case id
        case info
        case object
        case time
    }

    /// Note: named `list`, not `listAll` — the response has no `count`/`pages` metadata, so
    /// there's no reliable way to know when to stop walking pages automatically. Pass `page`
    /// yourself if you need more than the first `limit` activities.
    public static func list(client: ClientProtocol, limit: Int? = nil, page: Int? = nil) async throws -> [DashboardActivity] {
        let data = try await client.get(endpoint: .dashboardActivities, id: nil, filters: nil, sort: nil, page: page, limit: limit)
        return try client.decode(data: data)
    }
}
