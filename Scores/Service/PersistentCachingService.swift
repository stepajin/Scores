//
//  PersistentCachingService.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import Foundation
import GRDB

private struct ResourceQuery: Codable, FetchableRecord, PersistableRecord {
    enum Key: String {
        case endpoint, resource, timestamp
    }
    let endpoint: String
    let resource: String
    let timestamp: TimeInterval
}

// Todo expiration
final class PersistentCachingService {
    private var dbWriter: DatabaseWriter?

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.eraseDatabaseOnSchemaChange = true
        migrator.registerMigration("createResourceQuery") { db in
            try db.create(table: ResourceQuery.databaseTableName) { t in
                t.column(ResourceQuery.Key.endpoint.rawValue, .text).primaryKey().unique().indexed().notNull()
                t.column(ResourceQuery.Key.resource.rawValue, .text).notNull()
                t.column(ResourceQuery.Key.timestamp.rawValue, .real).notNull()
            }
        }
        return migrator
    }
    
    private var dbURL: URL? {
        return try? FileManager()
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db", isDirectory: true)
            .appendingPathComponent("db.sqlite")
    }

    init() {
        guard let dbURL = dbURL else { return }
        do {
            let dbPool = try DatabasePool(path: dbURL.path)
            dbWriter = dbPool
            try migrator.migrate(dbPool)
        } catch let error {
            print(error)
        }
    }

    func fetchFromCache<R: Resource>(_ resource: R.Type, endpoint: Endpoint) async -> R? {
        do {
            let query = try await dbWriter?.read { db in
                try ResourceQuery.fetchOne(db, key: [ResourceQuery.Key.endpoint.rawValue: endpoint.path])
            }
            guard let base64 = query?.resource,
                  let data = Data.init(base64Encoded: base64) else {
                return nil
            }
            return try? JSONDecoder().decode(resource, from: data)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func cache<R: Resource>(_ resource: R, endpoint: Endpoint) async {
        guard let data = try? JSONEncoder().encode(resource) else { return }
        let string = data.base64EncodedString()
        let query = ResourceQuery(endpoint: endpoint.path, resource: string, timestamp: Date.now.timeIntervalSince1970)
        do {
            try await dbWriter?.write { db in
                try db.execute(sql: "INSERT OR REPLACE INTO \(ResourceQuery.databaseTableName) (endpoint, resource, timestamp) VALUES('\(query.endpoint)', '\(query.resource)', '\(query.timestamp)')")
            }
        } catch let error {
            print(error)
        }
    }
    
    func clear() async {
        do {
            try await dbWriter?.write { db in
                try db.execute(sql: "DELETE from \(ResourceQuery.databaseTableName)")
            }
        } catch let error {
            print(error)
        }
    }
}
