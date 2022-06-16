//
//  CompetitionStandingsViewModel.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

protocol CompetitionStandingsViewModelDelegate: AnyObject {
    func routeToTeam(_ team: Team)
}

final class CompetitionStandingsViewModel {
    let competition: Competition
    
    weak var delegate: CompetitionStandingsViewModelDelegate?
    var onTableUpdated: (([TableItem]) -> Void)?
    
    @Inject private var service: APIService
    private var standings: Standings?
    
    init(competition: Competition) {
        self.competition = competition
    }
    
    func fetchTable() -> Void {
        guard let code = competition.code else { return }
        Task {
            do {
                let standings = try await service.fetch(SeasonStandings.self, endpoint: .standings(id: code))
                processSeasonStandings(standings)
            } catch let error {
                print(error)
            }
        }
    }
    
    func selectTablePosition(_ position: Int) {
        guard let team = standings?.table.first(where: { $0.position == position })?.team else { return }
        delegate?.routeToTeam(team)
    }
    
    private func processSeasonStandings(_ seasonStandings: SeasonStandings) {
        guard let standings = seasonStandings.standings.first else { return }
        self.standings = standings
        DispatchQueue.main.async {
            self.onTableUpdated?(standings.table)
        }
    }
}
