//
//  PersistentCachingServiceTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 16.06.2022.
//

import XCTest
@testable import Scores

class PersistentCachingServiceTests: XCTestCase {

    let service = PersistentCachingService()
    
    func testFetch() async {
        let player: Player = ["id": 1, "name": "Player1"].resource()
        let endpoint = Endpoint.person(id: 1)
        await service.cache(player, endpoint: endpoint)
        let resource = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNotNil(resource)
        XCTAssertEqual(resource?.id, player.id)
    }
    
    func testClear() async {
        let player: Player = ["id": 1, "name": "Player1"].resource()
        let endpoint = Endpoint.person(id: 1)
        await service.cache(player, endpoint: endpoint)
        let resource1 = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNotNil(resource1)
        await service.clear()
        let resource2 = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNil(resource2)
    }

    func testOverwrite() async {
        let player1: Player = ["id": 1, "name": "Player1"].resource()
        let player2: Player = ["id": 1, "name": "Player2"].resource()
        let endpoint = Endpoint.person(id: 1)
        
        await service.cache(player1, endpoint: endpoint)
        let resource1 = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNotNil(resource1)
        XCTAssertEqual(resource1?.name, player1.name)
            
        await service.cache(player2, endpoint: endpoint)
        let resource2 = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNotNil(resource2)
        XCTAssertEqual(resource2?.name, player2.name)
    }
}
