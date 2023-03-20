import XCTest
@testable import AmiiboAPI

final class AmiiboAPITests: XCTestCase {
    func testFetchAmiibos() async throws {
        let allAmiibos = try await AmiiboAPI.amiibo().get()
        XCTAssertNotEqual(allAmiibos.count, 0)
        
        let marioAmiibos = try await AmiiboAPI.amiibo(character: "mario").get()
        XCTAssertNotEqual(marioAmiibos.count, 0)
        
        let emptyAmiibos = try await AmiiboAPI.amiibo(character: "thisdoesntexist").get()
        XCTAssertEqual(emptyAmiibos.count, 0)
        
        let amiibo = try await AmiiboAPI.amiibo(byID: "0000000000000002").get()
        XCTAssertNotNil(amiibo)
        
        let nonExistantAmiibo = try await AmiiboAPI.amiibo(byID: "0000000000000000").get()
        XCTAssertNil(nonExistantAmiibo)
    }
    
    func testFetchAmiibosUsages() async throws {
        let amiibos = try await AmiiboAPI.amiibo(head: "00000000", tail: "00000002", showUsage: true).get()
        XCTAssertNotEqual(amiibos.count, 0)
        
        let games = amiibos[0].gamesSwitch
        XCTAssertNotNil(games)
        
        guard let games = games else { return }
        XCTAssertGreaterThan(games.count, 0)
    }
    
    func testFetchAmiiboType() async throws {
        let types = try await AmiiboAPI.types().get()
        XCTAssertNotEqual(types.count, 0)
        
        let named = try await AmiiboAPI.types(byName: "figure").get()
        XCTAssertNotEqual(named.count, 0)
        
        let keyed = try await AmiiboAPI.type(byKey: "0x00").get()
        XCTAssertNotNil(keyed)
    }
    
    func testFetchAmiiboSeries() async throws {
        let series = try await AmiiboAPI.series().get()
        XCTAssertNotEqual(series.count, 0)
        
        let named = try await AmiiboAPI.series(byName: "Super Smash Bros.").get()
        XCTAssertNotEqual(named.count, 0)
        
        let keyed = try await AmiiboAPI.series(byKey: "0x00").get()
        XCTAssertNotNil(keyed)
    }
    
    func testFetchAmiiboGameSeries() async throws {
        let types = try await AmiiboAPI.gameSeries().get()
        XCTAssertNotEqual(types.count, 0)
        
        let named = try await AmiiboAPI.gameSeries(byName: "Super Mario").get()
        XCTAssertNotEqual(named.count, 0)
        
        let keyed = try await AmiiboAPI.gameSeries(byKey: "0x00").get()
        XCTAssertNotNil(keyed)
    }
    
    func testFetchAmiiboCharacter() async throws {
        let types = try await AmiiboAPI.characters().get()
        XCTAssertNotEqual(types.count, 0)
        
        let named = try await AmiiboAPI.characters(byName: "Mario").get()
        XCTAssertNotEqual(named.count, 0)
        
        let keyed = try await AmiiboAPI.character(byKey: "0x0000").get()
        XCTAssertNotNil(keyed)
    }
    
    func testFetchLastUpdated() async throws {
        let lastUpdated = try await AmiiboAPI.lastUpdated().get()
        XCTAssertNotEqual(lastUpdated, Date())
    }
}
