
//
//  Schema.swift
//  DatabaseSchema
//
//  Created by Taylor Lineman on 7/1/26.
//

import SwiftData

typealias JobListing = SchemaV2.JobListing
typealias JobApplicationEssay = SchemaV2.JobApplicationEssay

extension Schema {
    static let trackerSchema: Schema = Schema([
        JobListing.self,
        JobApplicationEssay.self
    ])
}

enum DatabaseMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [SchemaV1.self, SchemaV2.self]
    static let stages: [MigrationStage] = [.lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self)]
}

enum SchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    
    static let models: [any PersistentModel.Type] = [
        SchemaV1.JobListing.self
    ]
}

enum SchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)
    
    static let models: [any PersistentModel.Type] = [
        SchemaV2.JobListing.self,
        SchemaV2.JobApplicationEssay.self
    ]
}
