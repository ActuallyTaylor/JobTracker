//
//  JobStatus.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

enum JobStatus: Int, Codable, CaseIterable, CustomStringConvertible {
    case unapplied
    case applied
    case interviewing
    case offer
    case passed
    case closed
    
    var description: String {
        switch self {
        case .unapplied:
            "To Apply"
        case .applied:
            "Applied"
        case .interviewing:
            "Interviewing"
        case .offer:
            "Offer"
        case .passed:
            "Passed"
        case .closed:
            "Closed"
        }
    }
}
