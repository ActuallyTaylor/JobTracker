//
//  JobStatus.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI

enum JobStatus: Int, Codable, CaseIterable, CustomStringConvertible {
    case unapplied
    case applied
    case interviewing
    case offer
    case accepted
    case rejected
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
        case .accepted:
            "Accepted"
        case .rejected:
            "Rejected"
        case .closed:
            "Closed"
        }
    }
    
    var color: Color {
        switch self {
        case .unapplied:
            return .primary
        case .applied:
            return .blue
        case .interviewing:
            return .purple
        case .offer:
            return .mint
        case .accepted:
            return .green
        case .rejected:
            return .orange
        case .closed:
            return .red
        }
    }
}
