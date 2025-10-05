//
//  WhiskedApp.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import SwiftData

@main
struct WhiskedApp: App {
    
    // MARK: - Properties
    
    /// Main coordinator for managing navigation throughout the app
    @State private var coordinator = WhiskedMainCoordinator()
    
    /// Shared model container for SwiftData persistence
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

    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            WhiskedDessertListView(coordinator: coordinator)
        }
        .modelContainer(sharedModelContainer)
    }
}
