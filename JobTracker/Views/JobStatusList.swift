//
//  JobStatusList.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/11/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

struct JobStatusList: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedJobs: Set<JobListing>
    var status: JobStatus
    var jobs: [JobListing]
        
    var body: some View {
        #if os(macOS)
        List(selection: $selectedJobs) {
            ForEach(jobs) { job in
                row(for: job)
            }
            .onDelete { indexSet in
                let jobsToDelete = jobs.enumerated().compactMap { element in
                    if indexSet.contains(element.offset) {
                        return element.element
                    } else {
                        return nil
                    }
                }

                delete(jobs: Set(jobsToDelete))
            }
        }
        .onDeleteCommand {
            delete(jobs: selectedJobs)
        }
        .navigationTitle(status.description)
        #else
        List(jobs, selection: $selectedJobs) { job in
            row(for: job)
        }
        .navigationTitle(status.description)
        .listStyle(.insetGrouped)
        #endif
    }
        
    @ViewBuilder
    func row(for listing: JobListing) -> some View {
        VStack(alignment: .leading) {
            Text(listing.name)
            Text(listing.companyName)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .tag(listing)
        .contextMenu {
            Button {
                // Activating a context menu does not always add the job to the selection, so add it here. It is a set so no need to worry about duplicates.
                selectedJobs.insert(listing)
                delete(jobs: selectedJobs)
            } label: {
                Label("Delete", systemSymbol: .trash)
            }
        }
    }
    
    private func delete(jobs: Set<JobListing>) {
        for index in jobs.indices {
            modelContext.delete(jobs[index])
        }
    }
}

#Preview {
    JobStatusList(selectedJobs: .constant([]), status: .applied, jobs: [
        JobListing(status: .applied, name: "iOS Engineer", companyName: "Taylor Lineman", url: URL(string: "https://actuallytaylor.com")!, notes: "This job is awesome and I am so excited for it.", location: "Remote", compensation: Compensation(salaryMin: 135000, salaryMax: 165000, hourlyRate: 65), creationDate: .now)
    ])
}
