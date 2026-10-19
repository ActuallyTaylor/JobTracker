//
//  JobBoard.swift
//  JobTracker
//
//  Created by Claude (Opus 5.5) on 10/18/26.
//

import Foundation
import SwiftData

extension SchemaV5 {
    @Model
    final class JobBoard {
        var name: String
        var url: URL
        var companyName: String? = nil
        /// Hash of the board's contents, used to detect changes on the website. `nil` until first computed.
        var contentHash: Int? = nil
        
        var creationDate: Date

        init(name: String, url: URL, companyName: String?, contentHash: Int?, creationDate: Date) {
            self.name = name
            self.url = url
            self.companyName = companyName
            self.contentHash = contentHash
            self.creationDate = creationDate
        }
    }
}
