//
//  RootView.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
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

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var jobListings: [JobListing]
    
    @State var selectedStatus: JobStatus? = .unapplied
    @State var selectedJobs: Set<JobListing> = []
    
    @State var presentJobCreationSheet: Bool = false

    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            if let selectedStatus {
                let jobs = jobListings.filter({ $0.status == selectedStatus })
                
                JobStatusList(selectedJobs: $selectedJobs, status: selectedStatus, jobs: jobs)
                    .toolbar {
                        Button {
                            presentJobCreationSheet.toggle()
                        } label: {
                            Label("Add Job Listing", systemSymbol: .plus)
                        }
                    }
            } else {
                Text("Select a Status")
            }
        } detail: {
            Group {
                if let selectedJob = selectedJobs.first {
                    JobListingView(jobListing: selectedJob)
                        .id(selectedJob.id)
                } else {
                    Text("Select a job to see details.")
                }
            }
        }
        .sheet(isPresented: $presentJobCreationSheet) {
            #if os(macOS)
            CreateJobListingSheet(jobStatus: selectedStatus ?? .unapplied)
            #else
            // Add a navigation stack to give the view a title and toolbar
            NavigationStack {
                CreateJobListingSheet(jobStatus: selectedStatus ?? .unapplied)
            }
            #endif
        }
    }
    
    var sidebar: some View {
        #if os(macOS)
        List(selection: $selectedStatus) {
            ForEach(JobStatus.allCases, id: \.description) { status in
                Text(status.description)
                    .badge(jobListings.filter({ $0.status == status }).count)
                    .tag(status)
            }
        }
        #else
        List(JobStatus.allCases, id: \.rawValue, selection: $selectedStatus) { status in
            Text(status.description)
                .badge(jobListings.filter({ $0.status == status }).count)
                .tag(status)
        }
        .navigationTitle("Application Status")
        #endif
    }
}

#Preview {
    RootView()
        .modelContainer(for: JobListing.self, inMemory: true)
}
