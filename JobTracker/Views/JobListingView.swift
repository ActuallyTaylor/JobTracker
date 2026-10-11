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

    let localeCurrency: String = Locale.current.currency?.identifier ?? "USD"

    init(jobListing: JobListing) {
        _jobListing = State(wrappedValue: jobListing)
        _stringifiedURL = State(wrappedValue: jobListing.url.absoluteString)
    }
    
    var body: some View {
        List {
            #if os(macOS)
            Section {
                macOSHeader
                    .listRowSeparator(.hidden)
            }
            .listSectionSeparator(.hidden)
            #else
            Section {
                LabeledContent {
                    Text(jobListing.location)
                } label: {
                    Text("Location")
                }
            }
            #endif
            
            if jobListing.compensation != nil {
                Section("Compensation") {
                    iOSCompensationList
                }
                .listRowSeparator(.hidden)
//                .listSectionSeparator(.hidden)
            }

            Section("Notes") {
                TextField("Notes", text: $jobListing.notes, axis: .vertical)
            }
            .listRowSeparator(.hidden)
//            .listSectionSeparator(.hidden)
            
            EssayListView(jobListing: jobListing)
//            .padding(.horizontal, 10)
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.plain)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    presentJobEditSheet.toggle()
                } label: {
                    Label("Edit Listing", systemSymbol: .pencilAndListClipboard)
                }
            }
            #if os(iOS)
            ToolbarItem {
                Link(destination: jobListing.url) {
                    Label("Open Application", systemSymbol: .link)
                }
            }
            #endif
        }
        .navigationTitle(jobListing.name)
        .navigationSubtitle(jobListing.companyName)
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
    
    var macOSHeader: some View {
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
    
    var iOSCompensationList: some View {
        VStack(alignment: .leading) {
            if let compensation = jobListing.compensation {
                if let salaryMin = compensation.salaryMin, let salaryMax = compensation.salaryMax {
                    LabeledContent("Salary") {
                        HStack {
                            Text(salaryMin, format: .currency(code: localeCurrency))
                            Text("-")
                            Text(salaryMax, format: .currency(code: localeCurrency))
                        }
                    }
                } else if let salaryMin = compensation.salaryMin {
                    LabeledContent("Salary starting at") {
                        Text(salaryMin, format: .currency(code: localeCurrency))
                    }
                } else if let salaryMax = compensation.salaryMax {
                    LabeledContent("Salary up to") {
                        Text(salaryMax, format: .currency(code: localeCurrency))
                    }
                }

                
                if let hourlyRate = compensation.hourlyRate {
                    LabeledContent("Hourly Rate") {
                        Text(hourlyRate, format: .currency(code: localeCurrency))
                    }
                }
            }
        }
    }
    
    /// A nice reactive UI for the salary range. It has a lot of if statemens becasue every field in the compensation package is option.
    var compensationHeader: some View {
        HStack(spacing: 3) {
            if let compensation = jobListing.compensation {
                if let salaryMin = compensation.salaryMin, let salaryMax = compensation.salaryMax {
                    Text(salaryMin, format: .currency(code: localeCurrency))
                    Text("-")
                    Text(salaryMax, format: .currency(code: localeCurrency))
                } else if let salaryMin = compensation.salaryMin {
                    Text("Starting At:")
                    Text(salaryMin, format: .currency(code: localeCurrency))
                } else if let salaryMax = compensation.salaryMax {
                    Text("Up to:")
                    Text(salaryMax, format: .currency(code: localeCurrency))
                }
                
                if let hourlyRate = compensation.hourlyRate {
                    if compensation.salaryMin != nil || compensation.salaryMax != nil {
                        Text("•")
                    }
                    
                    Text(hourlyRate, format: .currency(code: localeCurrency))
                    Text("/ hr")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        JobListingView(jobListing: JobListing(status: .applied, name: "iOS Engineer", companyName: "Taylor Lineman", url: URL(string: "https://actuallytaylor.com")!, notes: "This job is awesome and I am so excited for it.", location: "Remote", compensation: Compensation(salaryMin: 135000, salaryMax: 165000, hourlyRate: 65), creationDate: .now))
            .frame(width: 450)
    }
}
