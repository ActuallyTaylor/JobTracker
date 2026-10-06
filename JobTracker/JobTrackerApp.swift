//
//  JobTrackerApp.swift
//  JobTracker
//
//  Created by Taylor Lineman on 10/5/26.
//

import SwiftUI
import SwiftData

@main
struct JobTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: .trackerSchema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(
                for: .trackerSchema,
                migrationPlan: DatabaseMigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
