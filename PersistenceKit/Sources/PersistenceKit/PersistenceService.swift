//
//  PersistenceService.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData

/// Actor-based service for managing favorite desserts persistence using SwiftData
/// Ensures thread safety for all data access and mutations
public actor PersistenceService {
    
    // MARK: - Properties
    
    /// The SwiftData model context for persistence operations
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    
    /// Initializes the persistence service with a model context
    /// - Parameter modelContext: The SwiftData model context to use for persistence
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Public Methods
    
    /// Toggles the favorite status of a dessert
    /// If the dessert is already a favorite, it will be removed
    /// If the dessert is not a favorite, it will be added
    /// - Parameter mealID: The unique identifier of the meal to toggle
    public func toggleFavorite(mealID: String) async throws {
        let descriptor = FetchDescriptor<FavoriteDessert>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let existingFavorites = try modelContext.fetch(descriptor)
        
        if let existingFavorite = existingFavorites.first {
            // Remove from favorites
            modelContext.delete(existingFavorite)
        } else {
            // Add to favorites
            let newFavorite = FavoriteDessert(idMeal: mealID)
            modelContext.insert(newFavorite)
        }
        
        try modelContext.save()
    }
    
    /// Checks if a dessert is marked as favorite
    /// - Parameter mealID: The unique identifier of the meal to check
    /// - Returns: True if the dessert is a favorite, false otherwise
    public func isFavorite(mealID: String) async throws -> Bool {
        let descriptor = FetchDescriptor<FavoriteDessert>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let count = try modelContext.fetchCount(descriptor)
        return count > 0
    }
    
    /// Retrieves all favorite desserts
    /// - Returns: An array of all favorite desserts sorted by date added (most recent first)
    public func fetchFavorites() async throws -> [FavoriteDessert] {
        let descriptor = FetchDescriptor<FavoriteDessert>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        
        return try modelContext.fetch(descriptor)
    }
    
    /// Adds a dessert to favorites
    /// - Parameter mealID: The unique identifier of the meal to add
    /// - Note: This method will not add duplicates due to the unique constraint
    public func addToFavorites(mealID: String) async throws {
        let descriptor = FetchDescriptor<FavoriteDessert>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let existingFavorites = try modelContext.fetch(descriptor)
        
        // Only add if not already a favorite
        if existingFavorites.isEmpty {
            let newFavorite = FavoriteDessert(idMeal: mealID)
            modelContext.insert(newFavorite)
            try modelContext.save()
        }
    }
    
    /// Removes a dessert from favorites
    /// - Parameter mealID: The unique identifier of the meal to remove
    public func removeFromFavorites(mealID: String) async throws {
        let descriptor = FetchDescriptor<FavoriteDessert>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let existingFavorites = try modelContext.fetch(descriptor)
        
        for favorite in existingFavorites {
            modelContext.delete(favorite)
        }
        
        if !existingFavorites.isEmpty {
            try modelContext.save()
        }
    }
    
    /// Gets the count of favorite desserts
    /// - Returns: The total number of favorite desserts
    public func getFavoritesCount() async throws -> Int {
        let descriptor = FetchDescriptor<FavoriteDessert>()
        return try modelContext.fetchCount(descriptor)
    }
    
    /// Clears all favorite desserts
    /// - Warning: This operation cannot be undone
    public func clearAllFavorites() async throws {
        let descriptor = FetchDescriptor<FavoriteDessert>()
        let allFavorites = try modelContext.fetch(descriptor)
        
        for favorite in allFavorites {
            modelContext.delete(favorite)
        }
        
        if !allFavorites.isEmpty {
            try modelContext.save()
        }
    }
}