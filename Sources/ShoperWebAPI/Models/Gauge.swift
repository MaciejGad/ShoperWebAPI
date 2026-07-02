import Foundation

public struct Gauge: Decodable, Sendable {
    public let gaugeId: Int
    public let translations: [String: GaugeTranslation]

    public struct GaugeTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gaugeId = try container.decodeInt(forKey: .gaugeId)
        self.translations = (try? container.decode([String: GaugeTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case gaugeId
        case translations
    }
}

extension Gauge: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(gaugeId) }
    public static var endpoint: Endpoint { .gauges }
}
