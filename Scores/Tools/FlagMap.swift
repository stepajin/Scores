//
//  FlagMap.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

struct FlagMap {
    static let shared: FlagMap = FlagMap()
    static var map: [String: Item] { shared.map }
    
    struct Item: Codable {
        let name: String
        let code: String
        let emoji: String
        let unicode: String
        let image: String
    }
    
    let map: [String: Item]
    
    private init() {
        guard let path = Bundle.main.path(forResource: "flags", ofType: "json"),
              let jsonData = try? String(contentsOfFile: path).data(using: .utf8),
              let items = try? JSONDecoder().decode([Item].self, from: jsonData) else {
            map = [:]
            return
        }
        map = Dictionary(uniqueKeysWithValues: items.map { ($0.name, $0) })
    }
}
