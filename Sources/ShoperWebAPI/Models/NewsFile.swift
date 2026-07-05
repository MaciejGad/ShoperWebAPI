import Foundation

public struct NewsFile: Decodable, Sendable {
    public let fileId: Int
    public let name: String?
    /// Server-generated unique filename, distinct from `name` (the name given at upload time) —
    /// same `file_name` vs. `name` split as `ProductFile`.
    public let fileName: String?
    public let fileSize: Int?
    public let description: String?
    public let newsId: Int?
    public let order: Int?
    public let dateAdd: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fileId = try container.decodeInt(forKey: .fileId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
        self.fileSize = try container.decodeIntIfPresent(forKey: .fileSize)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.newsId = try container.decodeIntIfPresent(forKey: .newsId)
        self.order = try container.decodeIntIfPresent(forKey: .order)
        self.dateAdd = try container.decodeDateStringIfPresent(forKey: .dateAdd)
    }

    enum CodingKeys: CodingKey {
        case fileId
        case name
        case fileName
        case fileSize
        case description
        case newsId
        case order
        case dateAdd
    }
}

extension NewsFile: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = CreateNewsFile
    public typealias UpdatePayload = UpdateNewsFile

    public var id: Identifier { .id(fileId) }
    public static var endpoint: Endpoint { .newsFiles }
}
