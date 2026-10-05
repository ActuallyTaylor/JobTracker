
//
//  Schema.swift
//  DatabaseSchema
//
//  Created by Taylor Lineman on 7/1/26.
//

import SwiftData

typealias JobListing = SchemaV1.JobListing

extension Schema {
    static let trackerSchema: Schema = Schema([
        JobListing.self,
    ])
}

enum DatabaseMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [SchemaV1.self]
    static let stages: [MigrationStage] = []
}

enum SchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    
    static let models: [any PersistentModel.Type] = [
        SchemaV1.JobListing.self
    ]
}
