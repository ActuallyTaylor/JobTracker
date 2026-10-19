
//
//  Schema.swift
//  DatabaseSchema
//
//  Created by Taylor Lineman on 7/1/26.
//

import SwiftData

// Written by Claude (Opus 5.5): point the typealiases at SchemaV5 and add JobBoard.
typealias JobListing = SchemaV5.JobListing
typealias JobApplicationEssay = SchemaV5.JobApplicationEssay
typealias Compensation = SchemaV5.Compensation
typealias JobBoard = SchemaV5.JobBoard

extension Schema {
    static let trackerSchema: Schema = Schema([
        JobListing.self,
        JobApplicationEssay.self,
        JobBoard.self // Written by Claude (Opus 5.5)
    ])
}

enum DatabaseMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [SchemaV1.self, SchemaV2.self, SchemaV3.self, SchemaV4.self, SchemaV5.self]
    
    static let stages: [MigrationStage] = [
        .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self),
        .lightweight(fromVersion: SchemaV2.self, toVersion: SchemaV3.self),
        .lightweight(fromVersion: SchemaV3.self, toVersion: SchemaV4.self),
        .lightweight(fromVersion: SchemaV4.self, toVersion: SchemaV5.self) // Written by Claude (Opus 5.5)
    ]
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

enum SchemaV3: VersionedSchema {
    static let versionIdentifier = Schema.Version(3, 0, 0)
    
    static let models: [any PersistentModel.Type] = [
        SchemaV3.JobListing.self,
        SchemaV3.JobApplicationEssay.self
    ]
}

enum SchemaV4: VersionedSchema {
    static let versionIdentifier = Schema.Version(4, 0, 0)
    
    static let models: [any PersistentModel.Type] = [
        SchemaV4.JobListing.self,
        SchemaV4.JobApplicationEssay.self
    ]
}

// Written by Claude (Opus 5.5): SchemaV5 adds the JobBoard model.
enum SchemaV5: VersionedSchema {
    static let versionIdentifier = Schema.Version(5, 0, 0)
    
    static let models: [any PersistentModel.Type] = [
        SchemaV5.JobListing.self,
        SchemaV5.JobApplicationEssay.self,
        SchemaV5.JobBoard.self
    ]
}
