//
//  ContentView.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var jobListings: [JobListing]
    
    @State var selectedStatus: JobStatus = .unapplied
    @State var selectedJobs: Set<JobListing> = []
    
    @State var presentJobCreationSheet: Bool = false

    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            let jobs = jobListings.filter({ $0.status == selectedStatus })
            
            List(selection: $selectedJobs) {
                ForEach(jobs) { job in
                    VStack(alignment: .leading) {
                        Text(job.name)
                        Text(job.companyName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tag(job)
                    .contextMenu {
                        Button {
                            // Activating a context menu does not always add the job to the selection, so add it here. It is a set so no need to worry about duplicates.
                            selectedJobs.insert(job)
                            delete(jobs: selectedJobs)
                        } label: {
                            Label("Delete", systemSymbol: .trash)
                        }
                    }
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
                .onDeleteCommand {
                    delete(jobs: selectedJobs)
                }
            }
        } detail: {
            Group {
                if let selectedJob = selectedJobs.first {
                    Text(selectedJob.name)
                } else {
                    Text("Select a job to see details.")
                }
            }
            .toolbar {
                Button {
                    presentJobCreationSheet.toggle()
                } label: {
                    Label("Add Job Listing", systemSymbol: .plus)
                }
            }
        }
        .sheet(isPresented: $presentJobCreationSheet) {
            CreateJobListingSheet()
        }
    }
    
    var sidebar: some View {
        List(selection: $selectedStatus) {
            ForEach(JobStatus.allCases, id: \.description) { status in
                Text(status.description)
                    .badge(jobListings.filter({ $0.status == status }).count)
                    .tag(status)
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
    ContentView()
        .modelContainer(for: JobListing.self, inMemory: true)
}
