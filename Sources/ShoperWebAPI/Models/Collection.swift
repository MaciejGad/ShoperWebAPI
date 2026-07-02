import Foundation

public struct Collection: Decodable, Sendable {
    public let collectionId: Int
    public let sortType: Int?
    public let imageBackground: String?
    public let imageThumbnail: String?
    public let translations: [String: CollectionTranslation]

    public struct CollectionTranslation: Decodable, Sendable {
        public let name: String?
        public let description: String?
        public let descriptionBottom: String?
    }

    public func name(locale: String = "pl_PL") -> String? {
        translations[locale]?.name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.collectionId = try container.decodeInt(forKey: .collectionId)
        self.sortType = try container.decodeIntIfPresent(forKey: .sortType)
        self.imageBackground = try container.decodeIfPresent(String.self, forKey: .imageBackground)
        self.imageThumbnail = try container.decodeIfPresent(String.self, forKey: .imageThumbnail)
        self.translations = (try? container.decode([String: CollectionTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case collectionId
        case sortType
        case imageBackground
        case imageThumbnail
        case translations
    }
}

extension Collection: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(collectionId) }
    public static var endpoint: Endpoint { .collections }
}
