//
//  CachingServiceTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 16.06.2022.
//

import XCTest
@testable import Scores

class CachingServiceTests: XCTestCase {
    
    func test1FetchFromNetwork() async throws {
        let service = CachingService()
        await service.clear()
        let (player, source) = try await service.fetchAndCache(Player.self, endpoint: .person(id: 1))
        XCTAssertEqual(player.id, 1)
        XCTAssertEqual(source, CachingService.Source.network)
    }
    
    func test2FetchFromDisk() async throws {
        let service = CachingService()
        let (player, source) = try await service.fetchAndCache(Player.self, endpoint: .person(id: 1))
        XCTAssertEqual(player.id, 1)
        XCTAssertEqual(source, CachingService.Source.disk)
    }
    
    func test3FetchFromMemory() async throws {
        let service = CachingService()
        let (player, source) = try await service.fetchAndCache(Player.self, endpoint: .person(id: 1))
        XCTAssertEqual(player.id, 1)
        XCTAssertNotEqual(source, CachingService.Source.memory)
        let (player2, source2) = try await service.fetchAndCache(Player.self, endpoint: .person(id: 1))
        XCTAssertEqual(player2.id, 1)
        XCTAssertEqual(source2, CachingService.Source.memory)
    }

}
