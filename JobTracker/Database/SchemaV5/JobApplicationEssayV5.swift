//
//  JobApplicationEssay.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//  Copied into SchemaV5 by Claude (Opus 5.5) on 10/18/26.
//

import SwiftData

extension SchemaV5 {
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
