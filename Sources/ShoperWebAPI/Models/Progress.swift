import Foundation

public struct Progress: Decodable, Sendable {
    public let progressId: Int
    public let name: String?
    /// 0 - pending, 1 - in progress, 2 - finished, 3 - aborted, 4 - failed,
    /// 5 - closed (finished and closed), 6 - aborted and closed, 7 - failed and closed.
    public let status: Int?
    public let nominator: Int?
    public let denominator: Int?
    public let eta: Int?
    public let etaUpdate: String?
    public let added: String?
    public let start: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.progressId = try container.decodeInt(forKey: .progressId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.status = try container.decodeIntIfPresent(forKey: .status)
        self.nominator = try container.decodeIntIfPresent(forKey: .nominator)
        self.denominator = try container.decodeIntIfPresent(forKey: .denominator)
        self.eta = try container.decodeIntIfPresent(forKey: .eta)
        self.etaUpdate = try container.decodeIfPresent(String.self, forKey: .etaUpdate)
        self.added = try container.decodeIfPresent(String.self, forKey: .added)
        self.start = try container.decodeIfPresent(String.self, forKey: .start)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case progressId
        case name
        case status
        case nominator
        case denominator
        case eta
        case etaUpdate
        case added
        case start
    }
}

extension Progress: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(progressId) }
    public static var endpoint: Endpoint { .progresses }
}
