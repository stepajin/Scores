//
//  CompetitionsListViewModel.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

protocol CompetitionsListViewModelDelegate: AnyObject {
    func routeToCompetition(_ competition: Competition)
}

final class CompetitionsListViewModel {
    weak var delegate: CompetitionsListViewModelDelegate?
    
    var onCompetitionsUpdated: (([CompetitionsListSection]) -> Void)?
    
    @Inject var service: APIService
    private var competitions: [Competition] = []
    
    func selectCompetition(_ id: Int) {
        guard let competition = competitions.first(where: { $0.id == id }) else {
            return
        }
        delegate?.routeToCompetition(competition)
    }
    
    func fetchCompetitons() {
        Task {
            do {
                let competitions = try await service.fetch(Competitions.self, endpoint: .competitions)
                processFetchedCompetitions(competitions)
            } catch let error {
                print(error)
            }
        }
    }
    
    func refreshCompetitions() {
        processAvailableCompetitions()
    }
    
    private func processFetchedCompetitions(_ competitions: Competitions) {
        let availableCompetitions = competitions.competitions.filter { $0.plan == "TIER_ONE" }
        self.competitions = availableCompetitions
        processAvailableCompetitions()
    }
    
    private func processAvailableCompetitions() {
        guard competitions.count > 0 else { return }
        
        let favoriteCompetitionsIds = UserDefaults.standard.favoriteCompetitionsIds
        
        let favoriteCompetitions = competitions.filter {
            favoriteCompetitionsIds.contains($0.id)
        }
        
        let favoriteSection = CompetitionsListSection(
            title: "⭐️  Favorites",
            rows: favoriteCompetitions.map {
                CompetitionListRow(
                    id: $0.id,
                    name: $0.name,
                    emblemURL: $0.emblemURL
                )
            }
        )
        
        let otherCompetitions = competitions.filter {
            !favoriteCompetitionsIds.contains($0.id)
        }
        
        let map = Dictionary<Int, [Competition]>(grouping: otherCompetitions) { $0.area?.id ?? 0 }
        
        let otherSections = map.keys.map { areaId -> CompetitionsListSection in
            let competitions = map[areaId, default: []]
            let area = competitions.first?.area

            let rows = competitions.map {
                CompetitionListRow(
                    id: $0.id,
                    name: $0.name,
                    emblemURL: $0.emblemURL ?? area?.flagURL
                )
            }

            let name = area?.name ?? ""
            let flag = FlagMap.map[name]?.emoji ?? "🌎"
            let title = "\(flag)  \(name)"
            
            return CompetitionsListSection(
                title: title,
                rows: rows
            )
        }.sorted { $0.title <= $1.title }
        
        let sections = favoriteSection.rows.count > 0
            ? [favoriteSection] + otherSections
            : otherSections
        
        updateCompetitionSections(sections)
    }
    
    private func updateCompetitionSections(_ sections: [CompetitionsListSection]) {
        DispatchQueue.main.async {
            self.onCompetitionsUpdated?(sections)
        }
    }
}
