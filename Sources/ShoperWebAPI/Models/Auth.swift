import Foundation

struct Auth: Codable {
    let accessToken: String
    let expiresIn: TimeInterval
    let tokenType: String
    let expirationDate: Date
    
    var currentDate: () -> Date = Date.init
    
    func isValid() -> Bool {
        expirationDate > currentDate()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        expiresIn = try container.decode(TimeInterval.self, forKey: .expiresIn)
        expirationDate = currentDate().addingTimeInterval(expiresIn)
        tokenType = try container.decode(String.self, forKey: .tokenType)
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case expiresIn
        case tokenType
    }
}
