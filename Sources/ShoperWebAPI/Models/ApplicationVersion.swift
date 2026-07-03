import Foundation

/// `GET /application-version` — a singleton resource (no list, no id).
public struct ApplicationVersion: Decodable, Sendable {
    /// Shop system version, e.g. "x.y.z".
    public let version: String

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(String.self, forKey: .version)
    }

    enum CodingKeys: CodingKey {
        case version
    }

    public static func get(client: ClientProtocol) async throws -> ApplicationVersion {
        let data = try await client.get(endpoint: .applicationVersion, id: nil, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }
}
