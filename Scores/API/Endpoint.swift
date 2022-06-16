//
//  Endpoint.swift
//  Scores
//
//  Created by Jindrich Stepanek on 16.06.2022.
//

import Foundation

enum Endpoint: Equatable, Hashable {
    case areas
    case area(id: Int)
    case standings(id: String)
    case competitions
    case team(id: Int)
    case scorers(id: String)
    case person(id: Int)
    
    var path: String {
        switch self {
        case .areas:
            return "/areas/"
        case .area(let id):
            return "/areas/\(id)"
        case .standings(let id):
            return "/competitions/\(id)/standings"
        case .competitions:
            return "/competitions/"
        case .team(let id):
            return "/teams/\(id)"
        case .scorers(let id):
            return "/competitions/\(id)/scorers?limit=20"
        case .person(let id):
            return "/persons/\(id)"
        }
    }
}
