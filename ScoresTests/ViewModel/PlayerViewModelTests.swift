//
//  PlayerViewModelTests.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import XCTest
@testable import Scores
import Combine

class PlayerViewModelTests: XCTestCase {

    let mockService = MockService()

    var viewModel: PlayerViewModel!
    var task: AnyCancellable?
    
    override func setUp() {
        DI.container.register(APIService.self) { _ in
            self.mockService
        }
    }
    
    @MainActor
    func testTeamFetch() {
        let exp = XCTestExpectation()

        let player: Player = ["id": 1, "name": "Player"].resource()
        let team: Team = ["id": 1, "name": "Team"].resource()
        let fullPlayer = Player(
            id: player.id,
            name: player.name,
            position: nil,
            dateOfBirth: nil,
            nationality: nil,
            shirtNumber: nil,
            currentTeam: team
        )
        mockService.addResource(fullPlayer, for: .person(id: 1))
        
        viewModel = PlayerViewModel(player: player, team: nil)
        
        task = viewModel.$team.dropFirst().sink { team in
            XCTAssertNotNil(team)
            XCTAssertEqual(team!.id, 1)
            XCTAssertEqual(team!.name, "Team")
            exp.fulfill()
        }
        
        viewModel.fetchTeam()
        
        wait(for: [exp], timeout: 10)
    }
}
