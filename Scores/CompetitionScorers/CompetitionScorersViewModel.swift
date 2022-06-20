//
//  CompetitionScorersViewModel.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

protocol CompetitionScorersViewModelDelegate: AnyObject {
    func routeToScorer(_ scorer: Scorer)
}

@MainActor
final class CompetitionScorersViewModel {
    let competition: Competition
    
    weak var delegate: CompetitionScorersViewModelDelegate?
    var onScorersUpdated: (([Scorer]) -> Void)?
    
    @Inject private var service: APIService
    private var scorers: Scorers?
    
    init(competition: Competition) {
        self.competition = competition
    }
    
    func fetchScorers() -> Void {
        guard let code = competition.code else { return }
        Task {
            do {
                let scorers = try await service.fetch(Scorers.self, endpoint: .scorers(id: code))
                processScorers(scorers)
            } catch let error {
                print(error)
            }
        }
    }
    
    func selectPlayer(_ id: Int) {
        guard let scorer = scorers?.scorers.first(where: { $0.player.id == id }) else { return }
        delegate?.routeToScorer(scorer)
    }
    
    private func processScorers(_ scorers: Scorers) {
        self.scorers = scorers
        self.onScorersUpdated?(scorers.scorers)
    }
}
