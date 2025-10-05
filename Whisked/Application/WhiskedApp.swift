//
//  WhiskedApp.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import SwiftData
// TODO: Add PersistenceKit import once the package dependency is added
// import PersistenceKit

@main
struct WhiskedApp: App {
    
    // MARK: - Properties
    
    /// Main coordinator for managing navigation throughout the app
    @State private var coordinator = WhiskedMainCoordinator()
    
    /// Shared model container for SwiftData persistence
    /// This will be updated to use PersistenceKit.createModelContainer() once the dependency is added
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            // TODO: Add FavoriteDessert.self here once PersistenceKit is added
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
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.createCategoryListView()
                    .navigationDestination(for: WhiskedMainCoordinator.Destination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
