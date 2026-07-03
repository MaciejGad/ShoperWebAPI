import Foundation

/// `/application-lock` — a singleton resource that locks administrator panel access.
///
/// Only `get` (reading the current lock state) is implemented here. Engaging the lock via
/// `POST`/`PUT` was intentionally left out: it can lock administrators out of the shop panel,
/// which is too risky to verify against a live store without explicit confirmation, and
/// `ClientProtocol`'s `post`/`put`/`delete` methods are shaped around id-based resources while
/// this endpoint has no id in its URL.
public struct ApplicationLock: Decodable, Sendable {
    public let locked: Bool?
    /// Unix timestamp of when the lock was engaged.
    public let date: Int?
    public let message: String?
    public let userId: Int?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locked = try container.decodeBoolIfPresent(forKey: .locked)
        self.date = try container.decodeIntIfPresent(forKey: .date)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.userId = try container.decodeIntIfPresent(forKey: .userId)
    }

    enum CodingKeys: CodingKey {
        case locked
        case date
        case message
        case userId
    }

    public static func get(client: ClientProtocol) async throws -> ApplicationLock {
        let data = try await client.get(endpoint: .applicationLock, id: nil, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }
}
