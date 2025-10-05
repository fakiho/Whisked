//
//  PersistenceSetup.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData

/// Helper for setting up the PersistenceKit model container
public enum PersistenceSetup: Sendable {
    
    /// Creates a model container for PersistenceKit
    /// - Parameter inMemory: Whether to store data in memory only (useful for testing)
    /// - Returns: A configured ModelContainer for PersistenceKit
    /// - Throws: ModelContainer initialization errors
    public static func createModelContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            OfflineMeal.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
    
    /// Creates a persistence service with a new model context
    /// - Parameter container: The model container to use
    /// - Returns: A configured PersistenceService
    public static func createPersistenceService(with container: ModelContainer) -> PersistenceService {
        let context = ModelContext(container)
        return PersistenceService(modelContext: context)
    }
    
    /// Creates a persistence service with an in-memory container (useful for testing)
    /// - Returns: A configured PersistenceService with in-memory storage
    /// - Throws: ModelContainer initialization errors
    public static func createInMemoryPersistenceService() throws -> PersistenceService {
        let container = try createModelContainer(inMemory: true)
        return createPersistenceService(with: container)
    }
}