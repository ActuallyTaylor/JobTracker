//
//  JobApplicationEssay.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftData

extension SchemaV2 {
    @Model
    final class JobApplicationEssay {
        var name: String
        var content: String
        
        var listing: JobListing
     
        init(listing: JobListing, name: String, content: String) {
            self.listing = listing
            self.name = name
            self.content = content
        }
    }
}
