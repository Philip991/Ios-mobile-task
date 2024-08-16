//
//  mobile_taskApp.swift
//  mobile task
//
//  Created by Philip Oma on 14/08/2024.
//

import SwiftUI
import SwiftData

@main
struct mobile_taskApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {  // Ensure NavigationStack is at the root level
                ContentView()
            }

            
        }
        .modelContainer(sharedModelContainer)
    }
}
