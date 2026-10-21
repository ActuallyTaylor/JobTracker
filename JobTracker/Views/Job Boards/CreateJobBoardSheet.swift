//
//  CreateJobBoardSheet.swift
//  JobTracker
//
//  Created by Claude (Opus 5.5) on 10/18/26.
//

import SwiftUI
import SwiftData

struct CreateJobBoardSheet: View {
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
    
    @State var creationError: Error?

    @State var boardName: String = ""
    @State var companyName: String = ""
    @State var stringedURL: String = ""
    
    var submitDisabled: Bool {
        boardName == "" ||
        stringedURL == "" ||
        !isURLValid
    }
    
    var isURLValid: Bool {
        URL(string: stringedURL) != nil
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $boardName)
                TextField("Board URL", text: $stringedURL)
                    .textContentType(.URL)
                    #if !os(macOS)
                    .textInputAutocapitalization(.never)
                    #endif
            } header: {
                Text("**General Information** \(Text("*").foregroundColor(.red))")
            }
            
            Section("**Extras**") {
                TextField("Company", text: $companyName)
                    .textContentType(.organizationName)
            }
            
            if let creationError {
                Text(creationError.localizedDescription)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add Board", role: .confirm) {
                    do {
                        creationError = nil
                        guard let boardURL = URL(string: stringedURL) else {
                            throw CreationError.invalidURL
                        }
                        
                        // The content hash is computed later once the board has been fetched.
                        let board = JobBoard(name: boardName, url: boardURL, companyName: companyName.isEmpty ? nil : companyName, contentHash: nil, creationDate: .now)
                        modelContext.insert(board)
                        
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
        .navigationTitle("Add Job Board")
        #if os(macOS)
        .padding()
        #endif
    }
}

#Preview {
    #if os(macOS)
    CreateJobBoardSheet()
        .modelContainer(for: JobBoard.self, inMemory: true)
    #else
    // Add a navigation stack to give the view a title and toolbar
    NavigationStack {
        CreateJobBoardSheet()
    }
    .modelContainer(for: JobBoard.self, inMemory: true)
    #endif
}
