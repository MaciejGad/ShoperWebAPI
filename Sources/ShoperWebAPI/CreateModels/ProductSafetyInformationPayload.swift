import Foundation

public struct ProductSafetyInformationPayload: Encodable, Sendable {
    public var gpsrProducerId: Int?
    public var gpsrImporterId: Int?
    public var gpsrResponsibleId: Int?
    public var gpsrCertificates: [Int]?

    public init(
        gpsrProducerId: Int? = nil,
        gpsrImporterId: Int? = nil,
        gpsrResponsibleId: Int? = nil,
        gpsrCertificates: [Int]? = nil
    ) {
        self.gpsrProducerId = gpsrProducerId
        self.gpsrImporterId = gpsrImporterId
        self.gpsrResponsibleId = gpsrResponsibleId
        self.gpsrCertificates = gpsrCertificates
    }

    public init(copying safetyInformation: SafetyInformation) {
        self.gpsrProducerId = safetyInformation.gpsrProducerId
        self.gpsrImporterId = safetyInformation.gpsrImporterId
        self.gpsrResponsibleId = safetyInformation.gpsrResponsibleId
        self.gpsrCertificates = safetyInformation.gpsrCertificates
    }
}
