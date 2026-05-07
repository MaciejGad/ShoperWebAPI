import Foundation

public struct SafetyInformation: Codable, Sendable {
    public let gpsrProducerId: Int?
    public let gpsrImporterId: Int?
    public let gpsrResponsibleId: Int?
    public let gpsrCertificates: [Int]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gpsrProducerId = try container.decodeIntIfPresent(forKey: .gpsrProducerId)
        self.gpsrImporterId = try container.decodeIntIfPresent(forKey: .gpsrImporterId)
        self.gpsrResponsibleId = try container.decodeIntIfPresent(forKey: .gpsrResponsibleId)
        self.gpsrCertificates = try container.decodeIntArray(forKey: .gpsrCertificates)
    }
}
