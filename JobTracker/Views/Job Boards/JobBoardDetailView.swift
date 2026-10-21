//
//  JobBoardDetailView.swift
//  JobTracker
//
//  Created by Claude (Opus 5.5) on 10/18/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

struct JobBoardDetailView: View {
    var jobBoard: JobBoard
    
    var body: some View {
        List {
            #if os(macOS)
            Section {
                macOSHeader
                    .listRowSeparator(.hidden)
            }
            .listSectionSeparator(.hidden)
            #endif
            
            Section("Jobs") {
                // TODO: Show the jobs fetched from this board.
                ContentUnavailableView("No Jobs Yet", systemImage: SFSymbol.briefcase.rawValue, description: Text("Jobs from this board will appear here."))
            }
            .listRowSeparator(.hidden)
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.plain)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem {
                Link(destination: jobBoard.url) {
                    Label("Open Board", systemSymbol: .link)
                }
            }
            #endif
        }
        .navigationTitle(jobBoard.name)
        .navigationSubtitle(jobBoard.companyName ?? "")
    }
    
    var macOSHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(jobBoard.name)
                    .font(.title)
                HStack(spacing: 5) {
                    if let companyName = jobBoard.companyName, !companyName.isEmpty {
                        Text(companyName)
                        Text("•")
                    }
                    Text(jobBoard.url.host() ?? jobBoard.url.absoluteString)
                }
                .font(.headline)
            }
            
            Spacer()
            
            Link(destination: jobBoard.url) {
                HStack {
                    Text("Open Board")
                        .lineLimit(1)
                        .fixedSize() // Otherwise link will try and truncate the text
                    Image(systemSymbol: .arrowUpForward)
                        .accessibilityHidden(true)
                }
            }
            .buttonStyle(.glass)
        }
    }
}

#Preview {
    NavigationStack {
        JobBoardDetailView(jobBoard: JobBoard(name: "Engineering Careers", url: URL(string: "https://actuallytaylor.com/careers")!, companyName: "Taylor Lineman", contentHash: nil, creationDate: .now))
            .frame(width: 450)
    }
}
