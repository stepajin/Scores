//
//  NetworkServiceTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import XCTest
@testable import Scores

class NetworkServiceTests: XCTestCase {

    let service = NetworkService()
    
    func testFetchArea() async throws {
        try await testFetch(Area.self, endpoint: .area(id: 2267))
    }
    
    func testFetchSeasonStandings() async throws {
        try await testFetch(SeasonStandings.self, endpoint: .standings(id: "PL"))
    }
    
    func testFetchCompetitions() async throws {
        try await testFetch(Competitions.self, endpoint: .competitions)
    }

    func testFetch<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws {
        let resource = try await service.fetch(resource, endpoint: endpoint)
        XCTAssertNotNil(resource)
    }
}
