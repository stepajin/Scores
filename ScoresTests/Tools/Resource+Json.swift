//
//  Resource+Json.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation
@testable import Scores

extension Dictionary where Self.Key == String, Self.Value == Any {
    func resource<R: Resource>() -> R {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [])
        let json = String(data: data, encoding: String.Encoding.ascii)!
        let jsonData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(R.self, from: jsonData)
    }
}
