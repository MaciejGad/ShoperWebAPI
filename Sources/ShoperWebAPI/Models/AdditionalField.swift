import Foundation

public struct AdditionalField: Decodable, Sendable {
    public let fieldId: Int
    public let type: AdditionalFieldType?
    public let locate: AdditionalFieldLocate?
    public let active: Bool?
    public let checked: Bool?
    public let order: Int?
    public let req: Bool?
    public let translations: [String: FieldTranslation]

    public struct FieldTranslation: Decodable, Sendable {
        public let name: String?
        public let description: String?
        /// Options for `select`-type fields. Values are extracted regardless of whether the API
        /// returns them as plain strings (per the documented schema) or as richer objects with
        /// `{trans_id, option_id, lang_id, value}` (observed live) — only the display text is kept.
        public let options: [String]?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            if let plainOptions = try? container.decodeIfPresent([String].self, forKey: .options) {
                self.options = plainOptions
            } else {
                let objectOptions = try container.decodeIfPresent([OptionValue].self, forKey: .options)
                self.options = objectOptions?.map(\.value)
            }
        }

        private struct OptionValue: Decodable {
            let value: String
        }

        enum CodingKeys: CodingKey {
            case name
            case description
            case options
        }
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fieldId = try container.decodeInt(forKey: .fieldId)
        self.type = try container.decodeIfPresent(AdditionalFieldType.self, forKey: .type)
        self.locate = try container.decodeIfPresent(AdditionalFieldLocate.self, forKey: .locate)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.checked = try container.decodeBoolIfPresent(forKey: .checked)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.req = try container.decodeBoolIfPresent(forKey: .req)
        self.translations = (try? container.decode([String: FieldTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case fieldId
        case type
        case locate
        case active
        case checked
        case order
        case req
        case translations
    }
}

extension AdditionalField: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateAdditionalField
    public typealias UpdatePayload = UpdateAdditionalField

    public var id: Identifier { .id(fieldId) }
    public static var endpoint: Endpoint { .additionalFields }
}
