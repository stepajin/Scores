//
//  PlayerViewModel.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation
import Combine

@MainActor
final class PlayerViewModel: ObservableObject {
    @Published var player: Player
    @Published var team: Team?
    
    @Inject private var service: APIService

    init(player: Player, team: Team?) {
        self.player = player
        self.team = team
    }
    
    func fetchTeam() {
        let playerId = player.id
        Task {
            do {
                let fetchedPlayer = try await service.fetch(Player.self, endpoint: .person(id: playerId))
                processFetchedTeam(fetchedPlayer.currentTeam)
            } catch let error {
                print(error)
            }
        }
    }
    
    private func processFetchedTeam(_ team: Team?) {
        guard let team = team else { return }
        self.team = team
    }
}
