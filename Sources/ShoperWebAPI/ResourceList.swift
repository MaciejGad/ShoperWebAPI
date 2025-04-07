import Foundation

public struct ResourceList<Model>: Decodable where Model: Resource {
    public let count: Int
    public let pages: Int
    public let page: Int
    public let list: [Model]
    
    enum CodingKeys: CodingKey {
        case count
        case pages
        case page
        case list
    }
    
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<ResourceList<Model>.CodingKeys> = try decoder.container(keyedBy: ResourceList<Model>.CodingKeys.self)
        self.count = try container.decodeInt(forKey: ResourceList<Model>.CodingKeys.count)
        self.pages = try container.decode(Int.self, forKey: ResourceList<Model>.CodingKeys.pages)
        self.page = try container.decode(Int.self, forKey: ResourceList<Model>.CodingKeys.page)
        self.list = try container.decode([Model].self, forKey: ResourceList<Model>.CodingKeys.list)
    }
}

