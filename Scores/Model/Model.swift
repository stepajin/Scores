//
//  Model.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation
import Kingfisher

typealias Resource = Codable

struct Areas: Resource {
    let count: Int
    let areas: [Area]
}

struct Area: Resource {
    let id: Int
    let name: String
    let countryCode: String?
    let flag: String?
    let parentAreaId: Int?
    let parentArea: String?
    
    var flagURL: URL? {
        guard let flag = flag else { return nil }
        return URL(string: flag)
    }
}

struct Competitions: Resource {
    let competitions: [Competition]
}

struct Competition: Resource {
    let id: Int
    let name: String
    let code: String?
    let type: String?
    let emblem: String?
    let plan: String?
    let area: Area?
    
    var emblemURL: URL? {
        guard let emblem = emblem else { return nil }
        return URL(string: emblem)
    }
}

struct TableItem: Resource {
    let position: Int
    let team: Team
    let playedGames: Int
    let form: String
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
}

struct Player: Resource {
    let id: Int
    let name: String?
    let position: String?
    let dateOfBirth: String?
    let nationality: String?
    let shirtNumber: Int?
    let currentTeam: Team?
}

struct Team: Resource {
    let id: Int
    let name: String
    let shortName: String?
    let crest: String?
    let squad: [Player]?
    
    var crestURL: URL? {
        guard let crest = crest else { return nil }
        return URL(string: crest)
    }
}

struct Standings: Resource {
    let table: [TableItem]
}

struct SeasonStandings: Resource {
    let competition: Competition
    let standings: [Standings]
}

struct Scorer: Resource {
    let player: Player
    let team: Team?
    let goals: Int?
    let assists: Int?
    let penalties: Int?
}

struct Scorers: Resource {
    let competition: Competition
    let scorers: [Scorer]
}
