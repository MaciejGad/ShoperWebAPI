import Foundation

public struct AdditionalFieldOption: Decodable, Sendable {
    public let optionId: Int
    public let fieldId: Int?
    public let translations: [String: OptionTranslation]

    public struct OptionTranslation: Decodable, Sendable {
        public let value: String?
    }

    public func value(locale: String = "pl_PL") -> String? {
        translations[locale]?.value
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.optionId = try container.decodeInt(forKey: .optionId)
        self.fieldId = try container.decodeIntIfPresent(forKey: .fieldId)
        self.translations = (try? container.decode([String: OptionTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case optionId
        case fieldId
        case translations
    }
}

extension AdditionalFieldOption: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateAdditionalFieldOption
    public typealias UpdatePayload = UpdateAdditionalFieldOption

    public var id: Identifier { .id(optionId) }
    public static var endpoint: Endpoint { .additionalFieldOptions }
}
