import Foundation

public struct Status: Decodable, Sendable {
    public let statusId: Int
    public let active: Bool?
    public let color: String?
    public let `default`: Bool?
    public let emailChange: Bool?
    public let order: Int?
    /// Status type: 1 - new, 2 - opened, 3 - closed, 4 - not completed.
    public let type: Int?
    public let translations: [String: StatusTranslation]

    public struct StatusTranslation: Decodable, Sendable {
        public let name: String?
        public let message: String?
        public let messageHtml: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeInt(forKey: .statusId)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.default = try container.decodeBoolIfPresent(forKey: .default)
        self.emailChange = try container.decodeBoolIfPresent(forKey: .emailChange)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.type = try container.decodeIntIfPresent(forKey: .type)
        self.translations = (try? container.decode([String: StatusTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case statusId
        case active
        case color
        case `default`
        case emailChange
        case order
        case type
        case translations
    }
}

extension Status: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(statusId) }
    public static var endpoint: Endpoint { .statuses }
}
