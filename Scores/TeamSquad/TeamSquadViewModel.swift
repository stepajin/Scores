//
//  TeamSquadViewModel.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

protocol TeamSquadViewModelDelegate: AnyObject {
    func routeToPlayer(_ player: Player, team: Team)
}

@MainActor
final class TeamSquadViewModel {
    
    weak var delegate: TeamSquadViewModelDelegate?
    var onSquadUpdated: (([TeamSquadSection]) -> Void)?

    private(set) var team: Team
    
    @Inject private var service: APIService

    init(team: Team) {
        self.team = team
    }
    
    func fetchTeam() {
        guard team.squad == nil else {
            processTeam(team)
            return
        }
        let teamId = team.id
        Task {
            do {
                let team = try await service.fetch(Team.self, endpoint: .team(id: teamId))
                processTeam(team)
            } catch let error {
                print(error)
            }
        }
    }
    
    func selectPlayer(id: Int) {
        guard let player = team.squad?.first(where: { $0.id == id }) else {
            return
        }
        let _team = Team(
            id: team.id,
            name: team.name,
            shortName: team.shortName,
            crest: team.crest,
            squad: nil
        )
        delegate?.routeToPlayer(player, team: _team)
    }
    
    private func processTeam(_ team: Team) {
        self.team = team
        
        let map = Dictionary<String, [Player]>(grouping: team.squad ?? []) {
            $0.position ?? ""
        }
        let squad = map.keys.map { key in
            TeamSquadSection(name: key, players: map[key, default: []])
        }.sorted {
            sortKey($0.name) <= sortKey($1.name)
        }
        
        updateSquad(squad)
    }
    
    private func updateSquad(_ squad: [TeamSquadSection]) {
        onSquadUpdated?(squad)
    }
    
    private func sortKey(_ position: String) -> Int {
        switch position {
        case "Goalkeeper": return 0
        case "Defence": return 1
        case "Midfield": return 2
        case "Offence": return 3
        default: return 4
        }
    }
}
