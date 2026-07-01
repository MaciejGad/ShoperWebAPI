import Foundation

public struct ShoperAttribute: Decodable, Sendable {
    public let attributeId: Int
    public let attributeGroupId: Int
    public let name: String
    /// Attribute type: 0 = text field, 1 = checkbox, 2 = drop-down
    public let type: Int
    public let active: Bool
    /// Available options for drop-down attributes (type == 2).
    /// Values are preserved exactly as returned by the API — do not trim before sending back to POST.
    public let options: [String]
    public let order: Int
    public let description: String?
    public let `default`: String?

    public init(from decoder: any Decoder) throws {
        // The global decoder uses convertFromSnakeCase, so JSON keys are already converted.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attributeId = try container.decodeInt(forKey: .attributeId)
        self.attributeGroupId = try container.decodeInt(forKey: .attributeGroupId)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decodeInt(forKey: .type)
        self.active = try container.decodeBool(forKey: .active)
        self.order = (try? container.decodeInt(forKey: .order)) ?? 0
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.default = try container.decodeIfPresent(String.self, forKey: .default)
        self.options = Self.decodeOptions(from: container)
    }

    private static func decodeOptions(from container: KeyedDecodingContainer<CodingKeys>) -> [String] {
        guard let rawOptions = try? container.decode([RawOption].self, forKey: .options) else {
            return []
        }
        var seen = Set<String>()
        var result: [String] = []
        for option in rawOptions {
            let text = option.resolvedText
            guard let text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
            // Deduplicate by normalized key, keep exact API value (including trailing spaces)
            let key = text.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\u{00A0}", with: " ")
                .lowercased()
            if seen.insert(key).inserted {
                result.append(text)
            }
        }
        return result
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case attributeId
        case attributeGroupId
        case name
        case type
        case active
        case options
        case order
        case description
        case `default`
    }
}

// MARK: - Resource

extension ShoperAttribute: Resource {
    public typealias Key = AttributeFilterKey
    public typealias Sort = AttributeSortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(attributeId) }
    public static var endpoint: Endpoint { .attributes }
}

// MARK: - Option decoding

private struct RawOption: Decodable {
    let resolvedText: String?

    init(from decoder: any Decoder) throws {
        // Options can be plain strings, or objects with name/value/option keys, or objects with translations
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            resolvedText = string
            return
        }
        let container = try decoder.container(keyedBy: DynamicKey.self)
        for key in ["name", "value", "option", "label"] {
            if let text = try? container.decode(String.self, forKey: DynamicKey(stringValue: key)) {
                resolvedText = text
                return
            }
        }
        if let translationsText = Self.translationText(from: container) {
            resolvedText = translationsText
            return
        }
        resolvedText = nil
    }

    private static func translationText(from container: KeyedDecodingContainer<DynamicKey>) -> String? {
        let translationsKey = DynamicKey(stringValue: "translations")
        if let dict = try? container.decode([String: [String: String]].self, forKey: translationsKey) {
            for locale in ["pl_PL", "pl"] {
                for key in ["name", "value", "option", "label"] {
                    if let text = dict[locale]?[key] { return text }
                }
            }
            for localeDict in dict.values {
                for key in ["name", "value", "option", "label"] {
                    if let text = localeDict[key] { return text }
                }
            }
        }
        return nil
    }
}
