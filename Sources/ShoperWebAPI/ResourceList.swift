import Foundation

struct ResourceList<Model>: Decodable where Model: Resource {
    let count: Int
    let pages: Int
    let page: Int
    let list: [Model]
    
    enum CodingKeys: CodingKey {
        case count
        case pages
        case page
        case list
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<ResourceList<Model>.CodingKeys> = try decoder.container(keyedBy: ResourceList<Model>.CodingKeys.self)
        self.count = try container.decodeInt(forKey: ResourceList<Model>.CodingKeys.count)
        self.pages = try container.decode(Int.self, forKey: ResourceList<Model>.CodingKeys.pages)
        self.page = try container.decode(Int.self, forKey: ResourceList<Model>.CodingKeys.page)
        self.list = try container.decode([Model].self, forKey: ResourceList<Model>.CodingKeys.list)
    }
}

