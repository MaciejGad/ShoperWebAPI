import Foundation

struct SafetyInformation: Codable {
    let gpsrProducerId: Int?
    let gpsrImporterId: Int?
    let gpsrResponsibleId: Int?
    let gpsrCertificates: [Int]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gpsrProducerId = try container.decodeIntIfPresent(forKey: .gpsrProducerId)
        self.gpsrImporterId = try container.decodeIntIfPresent(forKey: .gpsrImporterId)
        self.gpsrResponsibleId = try container.decodeIntIfPresent(forKey: .gpsrResponsibleId)
        self.gpsrCertificates = try container.decodeIntArray(forKey: .gpsrCertificates)
    }
}
