import Foundation

public struct ShoperCategory: Decodable, Sendable {
    public let categoryId: Int
    public let order: Int?
    public let translations: [String: CategoryTranslation]

    public struct CategoryTranslation: Decodable, Sendable {
        public let name: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        // The global decoder uses convertFromSnakeCase, so JSON keys are already converted.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categoryId = try container.decodeInt(forKey: .categoryId)
        self.order = try? container.decodeInt(forKey: .order)
        self.translations = (try? container.decode([String: CategoryTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case categoryId
        case order
        case translations
    }
}

// MARK: - Resource

extension ShoperCategory: Resource {
    public typealias Key = CategoryFilterKey
    public typealias Sort = CategorySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(categoryId) }
    public static var endpoint: Endpoint { .categories }
}
