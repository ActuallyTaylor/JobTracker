//
//  JobApplicationEssay.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftData

extension SchemaV4 {
    @Model
    final class JobApplicationEssay {
        var name: String
        var content: String
        var isComplete: Bool = false
        
        var listing: JobListing
        
        init(listing: JobListing, name: String, content: String, isComplete: Bool) {
            self.listing = listing
            self.name = name
            self.content = content
            self.isComplete = isComplete
        }
    }
}
