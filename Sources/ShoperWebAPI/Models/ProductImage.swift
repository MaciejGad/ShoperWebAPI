import Foundation

struct ProductImage: Codable {
    let gfxId: Int
    let order: Int
    let name: String
    let unicName: String
    let hidden: Bool
    let `extension`: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gfxId = try container.decodeInt(forKey: .gfxId)
        self.order = try container.decodeInt(forKey: .order)
        self.name = try container.decode(String.self, forKey: .name)
        self.unicName = try container.decode(String.self, forKey: .unicName)
        self.hidden = try container.decodeBool(forKey: .hidden)
        self.extension = try container.decode(String.self, forKey: .extension)
    }
}
