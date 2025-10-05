//
//  WhiskedApp.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import SwiftData
import PersistenceKit

@main
struct WhiskedApp: App {
    
    // MARK: - Properties
    
    /// Main coordinator for managing navigation throughout the app
    @StateObject private var coordinator = WhiskedMainCoordinator()
    
    /// Shared model container for SwiftData persistence
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            OfflineMeal.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    /// Persistence service for managing offline favorites
    private var persistenceService: PersistenceService {
        // Create a new ModelContext that can be safely passed to the actor
        let context = ModelContext(sharedModelContainer)
        return PersistenceService(modelContext: context)
    }

    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.createCategoryListView()
                    .navigationDestination(for: WhiskedMainCoordinator.Destination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
            .onAppear {
                // Inject persistence service into coordinator once container is ready
                coordinator.configurePersistenceService(persistenceService)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
