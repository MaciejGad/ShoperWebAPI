import Foundation

enum Identifier: Codable {
    case id(Int)
    case none
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let id = try? container.decode(Int.self) {
            self = .id(id)
        } else {
            self = .none
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .id(let id):
            try container.encode(id)
        case .none:
            break
        }
    }
}
