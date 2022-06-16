//
//  CompetitionViewModel.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

final class CompetitionViewModel {
    let competition: Competition

    private(set) var isFavorite: Bool

    init(competition: Competition) {
        self.competition = competition
        isFavorite = UserDefaults.standard.isFavorite(id: competition.id)
    }
    
    func toggleFavorite() {
        if isFavorite {
            UserDefaults.standard.removeFavoriteCompetition(id: competition.id)
        } else {
            UserDefaults.standard.addFavoriteCompetition(id: competition.id)
        }
        isFavorite.toggle()
    }
    
}
