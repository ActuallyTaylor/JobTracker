//
//  JobBoardListView.swift
//  JobTracker
//
//  Created by Claude (Opus 5.5) on 10/18/26.
//

import SwiftUI
import SwiftData
import SFSafeSymbols

struct JobBoardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedBoards: Set<JobBoard>
    var boards: [JobBoard]
    
    @State var presentBoardCreationSheet: Bool = false
    
    var body: some View {
        Group {
            if boards.isEmpty {
                ContentUnavailableView {
                    Label("No Job Boards", systemSymbol: .link)
                } description: {
                    Text("Add a link to a job posting board to see its jobs.")
                } actions: {
                    Button("Add Job Board") {
                        presentBoardCreationSheet.toggle()
                    }
                }
            } else {
                content
            }
        }
        .navigationTitle("Job Boards")
        .toolbar {
            ToolbarItem {
                Button {
                    presentBoardCreationSheet.toggle()
                } label: {
                    Label("Add Job Board", systemSymbol: .plus)
                }
            }
        }
        .sheet(isPresented: $presentBoardCreationSheet) {
            #if os(macOS)
            CreateJobBoardSheet()
            #else
            // Add a navigation stack to give the view a title and toolbar
            NavigationStack {
                CreateJobBoardSheet()
            }
            #endif
        }
    }
    
    var content: some View {
        #if os(macOS)
        List(selection: $selectedBoards) {
            ForEach(boards) { board in
                row(for: board)
            }
            .onDelete { indexSet in
                delete(boards: Set(indexSet.map { boards[$0] }))
            }
        }
        .onDeleteCommand {
            delete(boards: selectedBoards)
        }
        #else
        List(boards, selection: $selectedBoards) { board in
            row(for: board)
        }
        .listStyle(.insetGrouped)
        #endif
    }
    
    @ViewBuilder
    func row(for board: JobBoard) -> some View {
        VStack(alignment: .leading) {
            Text(board.name)
            HStack(spacing: 5) {
                if let companyName = board.companyName, !companyName.isEmpty {
                    Text(companyName)
                    Text("•")
                }
                Text(board.url.host() ?? board.url.absoluteString)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .tag(board)
        .contextMenu {
            Button {
                // Activating a context menu does not always add the board to the selection, so add it here. It is a set so no need to worry about duplicates.
                selectedBoards.insert(board)
                delete(boards: selectedBoards)
            } label: {
                Label("Delete", systemSymbol: .trash)
            }
        }
    }
    
    private func delete(boards: Set<JobBoard>) {
        for board in boards {
            selectedBoards.remove(board)
            modelContext.delete(board)
        }
    }
}

#Preview {
    JobBoardListView(selectedBoards: .constant([]), boards: [
        JobBoard(name: "Engineering Careers", url: URL(string: "https://actuallytaylor.com/careers")!, companyName: "Taylor Lineman", contentHash: nil, creationDate: .now)
    ])
}
