import Foundation

public struct ProductFile: Decodable, Sendable {
    public let fileId: Int
    public let translationId: Int
    public let fileName: String
    public let name: String?
    public let description: String?
    public let active: Bool?
    /// File type: 0 - regular file, 1 - file containing product safety information.
    public let type: Int?
    public let fileSize: Int?
    public let order: Int?
    public let addDate: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fileId = try container.decodeInt(forKey: .fileId)
        self.translationId = try container.decodeInt(forKey: .translationId)
        self.fileName = try container.decode(String.self, forKey: .fileName)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.active = try container.decodeBoolIfPresent(forKey: .active)
        self.type = try container.decodeIntIfPresent(forKey: .type)
        self.fileSize = try container.decodeIntIfPresent(forKey: .fileSize)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.addDate = try container.decodeDateStringIfPresent(forKey: .addDate)
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case fileId
        case translationId
        case fileName
        case name
        case description
        case active
        case type
        case fileSize
        case order
        case addDate
    }
}

extension ProductFile: Resource {
    public typealias Key = ProductFileFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateProductFile
    public typealias UpdatePayload = UpdateProductFile

    public var id: Identifier { .id(fileId) }
    public static var endpoint: Endpoint { .productFiles }
}
