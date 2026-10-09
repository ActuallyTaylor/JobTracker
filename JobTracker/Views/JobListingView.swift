//
//  JobListingView.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

struct JobListingView: View {
    @State var jobListing: JobListing
    @State var stringifiedURL: String = ""
    
    @State var presentJobEditSheet: Bool = false

    init(jobListing: JobListing) {
        _jobListing = State(wrappedValue: jobListing)
        _stringifiedURL = State(wrappedValue: jobListing.url.absoluteString)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                    .padding(.top)
                
                TextEditor(text: $jobListing.notes)
                EssayListView(jobListing: jobListing)
            }
            .padding(.horizontal, 10)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    presentJobEditSheet.toggle()
                } label: {
                    Label("Edit Listing", systemSymbol: .pencilAndListClipboard)
                }
            }
        }
        .sheet(isPresented: $presentJobEditSheet) {
            #if os(macOS)
            CreateJobListingSheet(existingListing: jobListing)
            #else
            // Add a navigation stack to give the view a title and toolbar
            NavigationStack {
                CreateJobListingSheet(existingListing: jobListing)
            }
            #endif
        }
    }
    
    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(jobListing.name)
                    .font(.title)
                HStack {
                    Text(jobListing.companyName)
                    Text("•")
                    Text(jobListing.location)
                }
                .font(.headline)
                if let compensation = jobListing.compensation {
                    
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Link(destination: jobListing.url) {
                    HStack {
                        Text("Open Application")
                            .lineLimit(1)
                            .fixedSize() // Otherwise link will try and truncate the text
                        Image(systemSymbol: .arrowUpForward)
                            .accessibilityHidden(true)
                    }
                }
                .buttonStyle(.glass)

                Picker("Status", selection: $jobListing.status) {
                    ForEach(JobStatus.allCases, id: \.description) { status in
                        Text(status.description)
                            .tag(status)
                    }
                }
                .labelsHidden()
                .tint(jobListing.status.color)
            }
        }
    }
}

#Preview {
    JobListingView(jobListing: JobListing(status: .applied, name: "iOS Engineer", companyName: "Taylor Lineman", url: URL(string: "https://actuallytaylor.com")!, notes: "This job is awesome and I am so excited for it.", location: "Remote", compensation: Compensation(salaryMin: 135000, salaryMax: 165000, hourlyRate: 65), creationDate: .now))
        .frame(width: 350)
}
