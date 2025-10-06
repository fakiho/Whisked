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
    
    // MARK: - Public Methods
    
    /// Creates a new model context for actor isolation
    /// This ensures each actor gets its own context to avoid main queue warnings
    public func createActorContext() -> ModelContext? {
        guard let container = container else { return nil }
        return ModelContext(container)
    }
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton pattern
    /// Initializes the model container with all required models
    private init() {
        do {
            // Define the schema with PersistenceKit models
            let schema = Schema([
                OfflineMeal.self
            ])
            
            // Configure the model container
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