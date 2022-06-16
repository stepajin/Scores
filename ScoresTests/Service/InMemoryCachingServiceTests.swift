//
//  InMemoryCachingServiceTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 16.06.2022.
//

import XCTest
@testable import Scores

class InMemoryCachingServiceTests: XCTestCase {

    let service = InMemoryCachingService()
    
    override func setUp() {
        service.clear()
    }
    
    func testEmptyCache() async {
        let maybePlayer = await service.fetchFromCache(Player.self, endpoint: .person(id: 1))
        XCTAssertNil(maybePlayer)
    }
    
    func testFetchCachedResource() async {
        let endpoint = Endpoint.person(id: 1)
        let player: Player = ["id": 1, "name": "Player"].resource()
        await service.cache(player, endpoint: endpoint)
        let maybePlayer = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNotNil(maybePlayer)
        XCTAssertEqual(maybePlayer?.id, player.id)
        XCTAssertEqual(maybePlayer?.name, player.name)
    }
    
    func testClear() async {
        let endpoint = Endpoint.person(id: 1)
        let player: Player = ["id": 1, "name": "Player"].resource()
        await service.cache(player, endpoint: endpoint)
        service.clear()
        let maybePlayer = await service.fetchFromCache(Player.self, endpoint: endpoint)
        XCTAssertNil(maybePlayer)
    }
}
