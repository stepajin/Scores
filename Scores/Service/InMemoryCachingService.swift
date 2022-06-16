//
//  InMemoryCachingService.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation

final class InMemoryCachingService {
    // todo expiration / buffer size
    private var cache: [Endpoint: Resource] = [:]
    
    func fetchFromCache<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async -> R? {
        cache[endpoint] as? R
    }
    
    func cache<R: Resource>(_ resource: R, endpoint: Endpoint) async {
        cache[endpoint] = resource
    }
    
    func clear() {
        cache = [:]
    }
}
