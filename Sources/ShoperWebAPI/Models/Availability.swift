import Foundation

public struct Availability: Decodable, Sendable {
    public let availabilityId: Int?
    public let canBuy: Bool?
    public let from: Int?
    public let notifier: Bool?
    public let ranges: Bool?
    public let translations: [String: AvailabilityTranslation]

    public struct AvailabilityTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.availabilityId = try container.decodeIntIfPresent(forKey: .availabilityId)
        self.canBuy = try container.decodeBoolIfPresent(forKey: .canBuy)
        self.from = try container.decodeIntIfPresent(forKey: .from)
        self.notifier = try container.decodeBoolIfPresent(forKey: .notifier)
        self.ranges = try container.decodeBoolIfPresent(forKey: .ranges)
        self.translations = (try? container.decode([String: AvailabilityTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case availabilityId
        case canBuy
        case from
        case notifier
        case ranges
        case translations
    }
}

extension Availability: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { availabilityId.map { .id($0) } ?? .none }
    public static var endpoint: Endpoint { .availabilities }
}
