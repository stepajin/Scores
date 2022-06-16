//
//  MockService.swift
//  ScoresTests
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation
@testable import Scores

final class MockService: APIService {
    enum Error: Swift.Error {
        case notFound
    }
    private var resources: [Endpoint: Resource] = [:]
    
    func fetch<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async throws -> R {
        guard let resource = resources[endpoint] as? R else {
            throw Error.notFound
        }
        return resource
    }
    
    func addResource(_ resource: Resource, for endpoint: Endpoint) {
        resources[endpoint] = resource
    }
}
