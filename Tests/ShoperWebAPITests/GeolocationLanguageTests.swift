import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch geolocation dictionaries and languages from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchGeolocationCountries() async throws {
    let client = try makeClient()
    let list = try await GeolocationCountry.list(client: client)
    print("GeolocationCountries count: \(list.count)")
    for country in list.list.prefix(5) {
        print(" * #\(country.countryId) \(country.isocode ?? "") active:\(String(describing: country.active)) regions:\(String(describing: country.regions))")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchGeolocationRegions() async throws {
    let client = try makeClient()
    let list = try await GeolocationRegion.list(client: client)
    print("GeolocationRegions count: \(list.count)")
    for region in list.list.prefix(5) {
        print(" * #\(region.regionId) countryId:\(String(describing: region.countryId)) \(region.name ?? "")")
    }
}

@Test func testFetchGeolocationSubregions() async throws {
    let client = try makeClient()
    let list = try await GeolocationSubregion.list(client: client)
    print("GeolocationSubregions count: \(list.count)")
    for subregion in list.list.prefix(5) {
        print(" * #\(subregion.subregionId) regionId:\(String(describing: subregion.regionId)) \(subregion.name ?? "")")
    }
}

@Test func testFetchLanguages() async throws {
    let client = try makeClient()
    let list = try await Language.list(client: client)
    print("Languages count: \(list.count)")
    for language in list.list {
        print(" * #\(language.langId) \(language.locale ?? "") active:\(String(describing: language.active)) currencyId:\(String(describing: language.currencyId))")
    }
    #expect(!list.list.isEmpty)
}
