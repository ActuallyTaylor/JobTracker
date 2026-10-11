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
    
    var existingListing: JobListing?
    
    @State var creationError: Error?

    @State var jobName: String = ""
    @State var companyName: String = ""
    @State var jobStatus: JobStatus = .unapplied
    @State var stringedURL: String = ""
    @State var jobNotes: String = ""
    @State var location: String = ""
    
    @State var salaryMin: Int? = nil
    @State var salaryMax: Int? = nil
    @State var hourlyRate: Int? = nil
    
    let localeCurrency: String = Locale.current.currency?.identifier ?? "USD"
    
    init(jobStatus: JobStatus) {
        self._jobStatus = State(initialValue: jobStatus)
    }
    
    init(existingListing: JobListing) {
        self.existingListing = existingListing
        
        self._jobName = State(initialValue: existingListing.name)
        self._companyName = State(initialValue: existingListing.companyName)
        self._jobStatus = State(initialValue: existingListing.status)
        self._stringedURL = State(initialValue: existingListing.url.absoluteString)
        self._jobNotes = State(initialValue: existingListing.notes)
        self._location = State(initialValue: existingListing.location)
        
        if let compensation = existingListing.compensation {
            self._hourlyRate = State(initialValue: compensation.hourlyRate)
            self._salaryMin = State(initialValue: compensation.salaryMin)
            self._salaryMax = State(initialValue: compensation.salaryMax)
        }
    }
    
    var submitDisabled: Bool {
        jobName == "" ||
        companyName == "" ||
        stringedURL == "" ||
        location == "" ||
        !isURLValid
    }
    
    /// Make sure that there is both a salary min and salary max.
    var isCompensationValid: Bool { salaryMin != nil && salaryMax != nil }
    
    var isURLValid: Bool {
        URL(string: stringedURL) != nil
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $jobName)
                    .textContentType(.jobTitle)
                TextField("Company", text: $companyName)
                    .textContentType(.organizationName)
                TextField("Application URL", text: $stringedURL)
                    .textContentType(.URL)
                TextField("Location", text: $location)
                    .textContentType(.location)
                
                Picker("Status", selection: $jobStatus) {
                    ForEach(JobStatus.allCases, id: \.description) { status in
                        Text(status.description)
                            .tag(status)
                    }
                }
                .tint(jobStatus.color)
            } header: {
                Text("**General Information** \(Text("*").foregroundColor(.red))")
            }
            
            Section("**Compensation**") {
                TextField("Salary Min", value: $salaryMin, format: .currency(code: localeCurrency))
                    #if !os(macOS)
                    .keyboardType(.numbersAndPunctuation)
                    #endif
                TextField("Salary Max", value: $salaryMax, format: .currency(code: localeCurrency))
                    #if !os(macOS)
                    .keyboardType(.numbersAndPunctuation)
                    #endif
                TextField("Hourly", value: $hourlyRate, format: .currency(code: localeCurrency))
                    #if !os(macOS)
                    .keyboardType(.numbersAndPunctuation)
                    #endif
            }
#if !os(macOS)
            .keyboardType(.numberPad)
#endif
            
            Section("**Extras**") {
                TextField("Notes", text: $jobNotes, axis: .vertical)
            }
            
            
            if let creationError {
                Text(creationError.localizedDescription)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(existingListing == nil ? "Add Listing" : "Update Listing", role: .confirm) {
                    do {
                        creationError = nil
                        guard let listingURL = URL(string: stringedURL) else {
                            throw CreationError.invalidURL
                        }
                        
                        if let existingListing {
                            existingListing.name = jobName
                            existingListing.companyName = companyName
                            existingListing.status = jobStatus
                            existingListing.url = listingURL
                            existingListing.location = location
                            
                            // If any part of the compensation exists, create a compensation struct with the information.
                            if salaryMin != nil || salaryMax != nil || hourlyRate != nil {
                                existingListing.compensation = Compensation(salaryMin: salaryMin, salaryMax: salaryMax, hourlyRate: hourlyRate)
                            }
                            
                            modelContext.insert(existingListing)
                        } else {
                            
                            
                            
                            let job = JobListing(status: jobStatus, name: jobName, companyName: companyName, url: listingURL, notes: jobNotes, location: location, compensation: nil, creationDate: .now)
                            modelContext.insert(job)
                        }
                        
                        try modelContext.save()
                        dismiss()
                    } catch {
                        creationError = error
                    }
                }
                .disabled(submitDisabled)
                #if os(macOS)
                .buttonStyle(.glassProminent)
                #endif
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                #if os(macOS)
                .buttonStyle(.glass)
                #endif
            }
        }
        .navigationTitle("Add Application")
        #if os(macOS)
        .padding()
        #endif
    }
}

#Preview {
    #if os(macOS)
    CreateJobListingSheet(jobStatus: .unapplied)
            .modelContainer(for: [JobListing.self, JobApplicationEssay.self])
    #else
    // Add a navigation stack to give the view a title and toolbar
    NavigationStack {
        CreateJobListingSheet(jobStatus: .unapplied)
    }
    .modelContainer(for: [JobListing.self, JobApplicationEssay.self])

    #endif
}
