
//
//  Schema.swift
//  DatabaseSchema
//
//  Created by Taylor Lineman on 7/1/26.
//

import SwiftData

typealias JobListing = SchemaV4.JobListing
typealias JobApplicationEssay = SchemaV4.JobApplicationEssay
typealias Compensation = SchemaV4.Compensation

extension Schema {
    static let trackerSchema: Schema = Schema([
        JobListing.self,
        JobApplicationEssay.self
    ])
}

enum DatabaseMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [SchemaV1.self, SchemaV2.self, SchemaV3.self, SchemaV4.self]
    
    static let stages: [MigrationStage] = [
        .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self),
        .lightweight(fromVersion: SchemaV2.self, toVersion: SchemaV3.self),
        .lightweight(fromVersion: SchemaV3.self, toVersion: SchemaV4.self)
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
