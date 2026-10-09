//
//  EssayListView.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

struct EssayListView: View {
    @Environment(\.modelContext) var modelContext
    @State var jobListing: JobListing
    
//    /// Query for the job essays associated with this job listing. Not populated here, instead populated in the `init`.
//    @Query var jobEssays: [JobApplicationEssay]
    
    init(jobListing: JobListing) {
        self.jobListing = jobListing
    }
    
    var body: some View {
        Section {
            ForEach(jobListing.essays) { essay in
                EssayView(essay: essay)
            }
        } header: {
            HStack {
                Text("Application Essays")
                
                Spacer()
                
                Button {
                    let newEssay = JobApplicationEssay(listing: jobListing, name: "", content: "", isComplete: false)
                    modelContext.insert(newEssay)
                } label: {
                    Image(systemSymbol: .plus)
                }
            }
        }
    }
}

struct EssayView: View {
    @Environment(\.modelContext) var modelContext

    @State var essay: JobApplicationEssay
    @State var showTrash: Bool = false
    
    var body: some View {
        HStack {
            TextField("Name", text: $essay.name)
                .textFieldStyle(.plain)
                .font(.headline)
            
            if showTrash {
                Button(role: .destructive) {
                    modelContext.delete(essay)
                } label: {
                    Image(systemSymbol: .trash)
                }
                .tint(.red)
            }
        }
        .padding(.horizontal, 5)
        .onHover { hovering in
            withAnimation {
                showTrash = hovering
            }
        }
        TextEditor(text: $essay.content)
        Divider()
            .tint(.accentColor)
    }
}

#Preview {
    List {
        EssayListView(jobListing: JobListing(status: .applied, name: "iOS Engineer", companyName: "Taylor Lineman", url: URL(string: "https://actuallytaylor.com")!, notes: "This job is awesome and I am so excited for it.", location: "Remote", compensation: nil, creationDate: .now))
    }
    .modelContainer(try! ModelContainer(for: .trackerSchema, configurations: [
        ModelConfiguration(schema: .trackerSchema, isStoredInMemoryOnly: true)
    ]))
}

#Preview {
    EssayView(essay: JobApplicationEssay(listing: JobListing(status: .applied, name: "iOS Engineer", companyName: "Taylor Lineman", url: URL(string: "https://actuallytaylor.com")!, notes: "This job is awesome and I am so excited for it.", location: "", compensation: nil, creationDate: .now), name: "This is a test", content: "This is some test content about why I want to work for Taylor.", isComplete: true))
}
