//
//  JobListingCreationSheet.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData

struct CreateJobListingSheet: View {
    enum CreationError: LocalizedError {
        case invalidURL
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                "The provided URL is not a valid url."
            }
        }
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var creationError: Error?

    @State var jobName: String = ""
    @State var companyName: String = ""
    @State var jobStatus: JobStatus = .unapplied
    @State var stringedURL: String = ""
    @State var jobNotes: String = ""
    
    var submitDisabled: Bool {
        jobName == "" ||
        companyName == "" ||
        stringedURL == "" ||
        !isURLValid
    }
    
    var isURLValid: Bool {
        URL(string: stringedURL) != nil
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $jobName)
            TextField("Company", text: $companyName)
            TextField("Application URL", text: $stringedURL)
            
            Picker("Status", selection: $jobStatus) {
                ForEach(JobStatus.allCases, id: \.description) { status in
                    Text(status.description)
                        .tag(status)
                }
            }
            
            LabeledContent("Notes") {
                TextEditor(text: $jobNotes)
            }
            
            
            if let creationError {
                Text(creationError.localizedDescription)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add Listing", role: .confirm) {
                    do {
                        creationError = nil
                        guard let listingURL = URL(string: stringedURL) else {
                            throw CreationError.invalidURL
                        }
                        
                        let job = JobListing(status: jobStatus, name: jobName, companyName: companyName, url: listingURL, notes: jobNotes, creationDate: .now)
                        modelContext.insert(job)
                        try modelContext.save()
                        dismiss()
                    } catch {
                        creationError = error
                    }
                }
                .disabled(submitDisabled)
                .buttonStyle(.glassProminent)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(.glass)
            }
        }
    }
}

#Preview {
    CreateJobListingSheet()
        .modelContainer(for: JobListing.self, inMemory: true)
}
