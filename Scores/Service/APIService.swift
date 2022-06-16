//
//  APIService.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

protocol APIService {
    func fetch<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws -> R
}
