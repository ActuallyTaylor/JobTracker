//
//  JobListing.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//  Copied into SchemaV5 by Claude (Opus 5.5) on 10/18/26.
//

import Foundation
import SwiftData

extension SchemaV5 {
    struct Compensation: Codable, Equatable {
        var salaryMin: Int?
        var salaryMax: Int?
        var hourlyRate: Int?
    }
    
    @Model
    final class JobListing {
        static let empty: JobListing = JobListing(status: .unapplied, name: "", companyName: "", url: URL(string: "")!, notes: "", location: "", compensation: nil, creationDate: .now)
        
        var status: JobStatus
        var name: String
        var companyName: String
        var url: URL
        var notes: String
        var location: String = ""
        var compensation: Compensation? = nil
        
        @Relationship(deleteRule: .cascade, inverse: \JobApplicationEssay.listing)
        var essays: [JobApplicationEssay] = []
     
        var creationDate: Date

        init(status: JobStatus, name: String, companyName: String, url: URL, notes: String, location: String, compensation: Compensation?, creationDate: Date) {
            self.status = status
            self.name = name
            self.companyName = companyName
            self.url = url
            self.notes = notes
            self.location = location
            self.creationDate = creationDate
            self.compensation = compensation
        }
    }
}
