//
//  SwiftDataContextManager.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation
import SwiftData

/// Singleton class responsible for managing SwiftData model container and context
public final class SwiftDataContextManager: @unchecked Sendable {
    
    // MARK: - Singleton
    
    /// Shared instance of the SwiftData context manager
    public static let shared = SwiftDataContextManager()
    
    // MARK: - Properties
    
    /// The main model container for the app
    public var container: ModelContainer?
    
    /// The main model context for performing SwiftData operations
    public var context: ModelContext?
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton pattern
    /// Initializes the model container with all required models
    private init() {
        setupModelContainer()
    }
    
    // MARK: - Private Methods
    
    /// Sets up the model container with all required models
    private func setupModelContainer() {
        do {
            // Define the schema with PersistenceKit models
            let schema = Schema([
                OfflineMeal.self
            ])
            
            // Create a basic container configuration
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            // Create the container
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Create the main context
            if let container = container {
                context = ModelContext(container)
                
                // Configure autosave (optional)
                context?.autosaveEnabled = true
            }
            
        } catch {
            debugPrint("Error initializing SwiftData container:", error)
            // In a production app, you might want to handle this more gracefully
            container = nil
            context = nil
        }
    }
    
    // MARK: - Public Methods
    
    /// Saves the current context if there are pending changes
    /// - Throws: Any errors that occur during the save operation
    public func save() throws {
        guard let context = context else {
            throw SwiftDataContextManagerError.contextNotAvailable
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    /// Creates a new background context for performing operations off the main thread
    /// - Returns: A new ModelContext for background operations
    /// - Throws: SwiftDataContextManagerError if container is not available
    public func newBackgroundContext() throws -> ModelContext {
        guard let container = container else {
            throw SwiftDataContextManagerError.containerNotAvailable
        }
        
        return ModelContext(container)
    }
    
    /// Resets the context manager by reinitializing the container and context
    public func reset() {
        container = nil
        context = nil
        setupModelContainer()
    }
    
    /// Updates the schema with new models (call this to add additional models)
    /// - Parameter models: Array of model types to include in the schema
    public func updateSchema(with models: [any PersistentModel.Type]) {
        do {
            let schema = Schema(models)
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            if let container = container {
                context = ModelContext(container)
                context?.autosaveEnabled = true
            }
            
        } catch {
            debugPrint("Error updating SwiftData schema:", error)
            container = nil
            context = nil
        }
    }
    
    /// Creates a new PersistenceService using the shared context
    /// - Returns: A configured PersistenceService instance
    /// - Throws: SwiftDataContextManagerError if context is not available
    public func createPersistenceService() throws -> PersistenceService {
        guard let context = context else {
            throw SwiftDataContextManagerError.contextNotAvailable
        }
        
        return PersistenceService(modelContext: context)
    }
}

// MARK: - Error Types

/// Errors that can occur when working with SwiftDataContextManager
public enum SwiftDataContextManagerError: LocalizedError {
    case containerNotAvailable
    case contextNotAvailable
    
    public var errorDescription: String? {
        switch self {
        case .containerNotAvailable:
            return "Model container is not available. SwiftData may not be properly initialized."
        case .contextNotAvailable:
            return "Model context is not available. SwiftData may not be properly initialized."
        }
    }
}