//
//  RootView.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

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
            Group {
                if let selectedStatus {
                    let jobs = jobListings.filter({ $0.status == selectedStatus })
                    
                    JobStatusList(selectedJobs: $selectedJobs, status: selectedStatus, jobs: jobs)
                } else {
                    Text("Select a Status")
                }
            }
            .toolbar {
                Button {
                    presentJobCreationSheet.toggle()
                } label: {
                    Label("Add Job Listing", systemSymbol: .plus)
                }
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
        .listStyle(.sidebar)
        #else
        List(JobStatus.allCases, id: \.rawValue, selection: $selectedStatus) { status in
            Text(status.description)
                .badge(jobListings.filter({ $0.status == status }).count)
                .tag(status)
        }
        .navigationTitle("Application Status")
        .listStyle(.insetGrouped)
        #endif
    }
}

#Preview {
    RootView()
        .modelContainer(for: JobListing.self, inMemory: true)
}
