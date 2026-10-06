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
    }
    
    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(jobListing.name)
                    .font(.title)
                Text(jobListing.companyName)
                    .font(.headline)
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
    JobListingView(jobListing: JobListing(status: .applied, name: "iOS Engineer", companyName: "Taylor Lineman", url: URL(string: "https://actuallytaylor.com")!, notes: "This job is awesome and I am so excited for it.", creationDate: .now))
        .frame(width: 350)
}
