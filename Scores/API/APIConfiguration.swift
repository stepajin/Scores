//
//  APIConfiguration.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation

struct APIConfiguration {
    static var v4: APIConfiguration {
        APIConfiguration(
            host: "https://api.football-data.org",
            version: "v4",
            token: "b01c94be68a148e6aa5ef3f598dde469"
        )
    }
    
    let host: String
    let version: String
    let token: String
    
    func url(_ resource: Endpoint) -> URL {
        guard let url = URL(string: "\(host)/\(version)/\(resource.path)") else {
            fatalError("Invalid URL")
        }
        return url
    }
}

