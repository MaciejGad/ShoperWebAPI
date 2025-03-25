import Foundation

public struct ProductImage: Codable {
    public let gfxId: Int
    public let order: Int
    public let name: String
    public let unicName: String
    public let hidden: Bool
    public let `extension`: String
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gfxId = try container.decodeInt(forKey: .gfxId)
        self.order = try container.decodeInt(forKey: .order)
        self.name = try container.decode(String.self, forKey: .name)
        self.unicName = try container.decode(String.self, forKey: .unicName)
        self.hidden = try container.decodeBool(forKey: .hidden)
        self.extension = try container.decode(String.self, forKey: .extension)
    }
}
