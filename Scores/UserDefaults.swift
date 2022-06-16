//
//  UserDefaults.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

extension UserDefaults {
    private var favoriteCompetitionsIdsKey: String { "favoriteCompetitionsIdsKey" }
    var favoriteCompetitionsIds: [Int] {
        get { object(forKey: favoriteCompetitionsIdsKey) as? [Int] ?? [] }
        set { set(newValue, forKey: favoriteCompetitionsIdsKey) }
    }
    
    func isFavorite(id: Int) -> Bool {
        favoriteCompetitionsIds.contains(id)
    }
    
    func addFavoriteCompetition(id: Int) {
        var ids = favoriteCompetitionsIds
        guard !ids.contains(id) else { return }
        ids.append(id)
        favoriteCompetitionsIds = ids
    }
    
    func removeFavoriteCompetition(id: Int) {
        favoriteCompetitionsIds = favoriteCompetitionsIds.filter { $0 != id }
    }
}
