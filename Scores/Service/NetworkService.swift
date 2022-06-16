//
//  NetworkService.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation

struct NetworkService {
    @Inject private var api: APIConfiguration
    
    func fetch<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws -> R {
        let data = try await fetchData(endpoint: endpoint)
        return try JSONDecoder().decode(resource, from: data)
    }
    
    private func fetchData(endpoint: Endpoint) async throws -> Data {
        let url = api.url(endpoint)
        var request = URLRequest(url: url)
        request.addValue(api.token, forHTTPHeaderField: "X-Auth-Token")
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
