//
//  CachingService.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation

final class CachingService: APIService {
    let persistentService = PersistentCachingService()
    let inMemoryService = InMemoryCachingService()
    let networkService = NetworkService()
    
    enum Source: Int {
        case memory
        case disk
        case network
    }

    func fetch<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws -> R {
        let (resource, _) = try await fetchFromSources(resource, endpoint: endpoint)
        return resource
    }
    
    func fetchAndCache<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws -> (R, Source) {
        let (resource, source) = try await fetchFromSources(resource, endpoint: endpoint)
        await cache(resource, endpoint: endpoint, source: source)
        return (resource, source)
    }
    
    private func fetchFromSources<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws -> (R, Source) {
        if let resource = await inMemoryService.fetchFromCache(resource, endpoint: endpoint) {
            return (resource, .memory)
        }
        if let resource = await persistentService.fetchFromCache(resource, endpoint: endpoint) {
            return (resource, .disk)
        }
        let resource = try await networkService.fetch(resource, endpoint: endpoint)
        return (resource, .network)
    }
    
    func cache<R: Resource>(_ resource: R, endpoint: Endpoint, source: Source) async {
        if source.rawValue > Source.memory.rawValue {
            await inMemoryService.cache(resource, endpoint: endpoint)
        }
        if source.rawValue > Source.disk.rawValue {
            await persistentService.cache(resource, endpoint: endpoint)
        }
    }
    
    func clear() async {
        inMemoryService.clear()
        await persistentService.clear()
    }
}
