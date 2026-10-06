//
//  JobListing.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import Foundation
import SwiftData

extension SchemaV2 {
    @Model
    final class JobListing {
        static let empty: JobListing = JobListing(status: .unapplied, name: "", companyName: "", url: URL(string: "")!, notes: "", creationDate: .now)
        
        var status: JobStatus
        var name: String
        var companyName: String
        var url: URL
        var notes: String
        
        @Relationship(deleteRule: .cascade, inverse: \JobApplicationEssay.listing)
        var essays: [JobApplicationEssay] = []
     
        var creationDate: Date

        init(status: JobStatus, name: String, companyName: String, url: URL, notes: String, creationDate: Date) {
            self.status = status
            self.name = name
            self.companyName = companyName
            self.url = url
            self.notes = notes
            self.creationDate = creationDate
        }
    }
}
