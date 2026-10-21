//
//  RootView.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

enum BoardSection: Hashable {
    case discover
    case added
}

enum ViewSection: Hashable {
    case board(section: BoardSection)
    case job(status: JobStatus)
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var jobListings: [JobListing]
    // Written by Claude (Opus 5.5): job board data and selection.
    @Query private var jobBoards: [JobBoard]
    
    @State var selectedJobs: Set<JobListing> = []
    @State var selectedBoards: Set<JobBoard> = []
    
    @State var selectedSection: ViewSection? = .job(status: .unapplied)
    
    @State var presentJobCreationSheet: Bool = false

    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            Group {
                switch selectedSection {
                case .board(let section):
                    // Written by Claude (Opus 5.5): show the board list or the Discover stub.
                    switch section {
                    case .added:
                        JobBoardListView(selectedBoards: $selectedBoards, boards: jobBoards)
                    case .discover:
                        ContentUnavailableView("Discover is coming soon", systemImage: SFSymbol.sparkleMagnifyingglass.rawValue)
                    }
                case .job(let status):
                    let jobs = jobListings.filter({ $0.status == status })
                    
                    JobStatusList(selectedJobs: $selectedJobs, status: status, jobs: jobs)
                        // Written by Claude (Opus 5.5): attach the add button to the status list so it only shows alongside one.
                        .toolbar {
                            Button {
                                presentJobCreationSheet.toggle()
                            } label: {
                                Label("Add Job Listing", systemSymbol: .plus)
                            }
                        }
                case nil:
                    ContentUnavailableView("Please select a status or job board", systemImage: SFSymbol.exclamationmarkTriangle.rawValue)
                }
            }
        } detail: {
            Group {
                // Written by Claude (Opus 5.5): show board details in the board sections, job details otherwise.
                switch selectedSection {
                case .board:
                    if let selectedBoard = selectedBoards.first {
                        JobBoardDetailView(jobBoard: selectedBoard)
                            .id(selectedBoard.id)
                    } else {
                        Text("Select a board to see its jobs.")
                    }
                default:
                    if let selectedJob = selectedJobs.first {
                        JobListingView(jobListing: selectedJob)
                            .id(selectedJob.id)
                    } else {
                        Text("Select a job to see details.")
                    }
                }
            }
        }
        .sheet(isPresented: $presentJobCreationSheet) {
            // Written by Claude (Opus 5.5): default the new listing to the status currently being viewed.
            #if os(macOS)
            CreateJobListingSheet(jobStatus: selectedJobStatus)
            #else
            // Add a navigation stack to give the view a title and toolbar
            NavigationStack {
                CreateJobListingSheet(jobStatus: selectedJobStatus)
            }
            #endif
        }
    }
    
    // Written by Claude (Opus 5.5): the status of the selected section, used as the default for new listings.
    var selectedJobStatus: JobStatus {
        if case .job(let status) = selectedSection {
            status
        } else {
            .unapplied
        }
    }
    
    var sidebar: some View {
        #if os(macOS)
        List(selection: $selectedSection) {
            Section("Boards") {
                // Written by Claude (Opus 5.5): tag the board rows so they can be selected.
                Text("Discover")
                    .tag(ViewSection.board(section: .discover))
                Text("Added")
                    .tag(ViewSection.board(section: .added))
            }
            Section("Jobs") {
                ForEach(JobStatus.allCases, id: \.description) { status in
                    Text(status.description)
                        .badge(jobListings.filter({ $0.status == status }).count)
                        .tag(ViewSection.job(status: status))
                }
            }
        }
        .listStyle(.sidebar)
        #else
        // Written by Claude (Opus 5.5): select into selectedSection so the content column follows the sidebar on iOS.
        List(JobStatus.allCases, id: \.rawValue, selection: $selectedSection) { status in
            Text(status.description)
                .badge(jobListings.filter({ $0.status == status }).count)
                .tag(ViewSection.job(status: status))
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
