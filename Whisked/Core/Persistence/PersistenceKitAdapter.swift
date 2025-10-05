//
//  PersistenceKitAdapter.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData
import Combine
// TODO: Uncomment this once PersistenceKit is added as a dependency
// import PersistenceKit

/// Adapter class to bridge between the old UserDefaults-based favorites service
/// and the new PersistenceKit actor-based service
@MainActor
final class PersistenceKitAdapter: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var favorites: Set<String> = []
    
    // TODO: Uncomment this once PersistenceKit is added as a dependency
    // private let persistenceService: PersistenceService
    
    // MARK: - Initialization
    
    init(modelContext: ModelContext) {
        // TODO: Initialize with PersistenceService once PersistenceKit is added
        // self.persistenceService = PersistenceService(modelContext: modelContext)
        // TODO: Load initial favorites from PersistenceKit
        loadFavorites()
    }
    
    // MARK: - Public Methods
    
    /// Checks if a dessert is marked as favorite
    func isFavorite(_ dessertId: String) -> Bool {
        favorites.contains(dessertId)
    }
    
    /// Toggles the favorite status of a dessert
    func toggleFavorite(_ dessertId: String) {
        Task {
            // TODO: Use PersistenceService once available
            // try await persistenceService.toggleFavorite(mealID: dessertId)
            
            // Temporary implementation using UserDefaults
            if favorites.contains(dessertId) {
                favorites.remove(dessertId)
            } else {
                favorites.insert(dessertId)
            }
            saveFavorites()
            loadFavorites()
        }
    }
    
    /// Adds a dessert to favorites
    func addToFavorites(_ dessertId: String) {
        Task {
            // TODO: Use PersistenceService once available
            // try await persistenceService.addToFavorites(mealID: dessertId)
            
            // Temporary implementation
            favorites.insert(dessertId)
            saveFavorites()
            loadFavorites()
        }
    }
    
    /// Removes a dessert from favorites
    func removeFromFavorites(_ dessertId: String) {
        Task {
            // TODO: Use PersistenceService once available
            // try await persistenceService.removeFromFavorites(mealID: dessertId)
            
            // Temporary implementation
            favorites.remove(dessertId)
            saveFavorites()
            loadFavorites()
        }
    }
    
    // MARK: - Private Methods
    
    /// Loads favorites from the persistence layer
    private func loadFavorites() {
        Task {
            // TODO: Use PersistenceService once available
            // let favoriteDesserts = try await persistenceService.fetchFavorites()
            // let favoriteIds = Set(favoriteDesserts.map { $0.idMeal })
            // await MainActor.run {
            //     self.favorites = favoriteIds
            // }
            
            // Temporary implementation using UserDefaults for backward compatibility
            if let data = UserDefaults.standard.data(forKey: "WhiskedFavorites"),
               let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                await MainActor.run {
                    self.favorites = decoded
                }
            }
        }
    }
    
    /// Saves favorites to the persistence layer
    private func saveFavorites() {
        // TODO: Remove this method once PersistenceService is integrated
        // The PersistenceService handles saving automatically
        
        // Temporary implementation
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "WhiskedFavorites")
        }
    }
}

// MARK: - Migration Helper

extension PersistenceKitAdapter {
    
    /// Migrates existing UserDefaults favorites to PersistenceKit
    func migrateFromUserDefaults() async {
        // TODO: Implement once PersistenceKit is integrated
        // guard let data = UserDefaults.standard.data(forKey: "WhiskedFavorites"),
        //       let legacyFavorites = try? JSONDecoder().decode(Set<String>.self, from: data) else {
        //     return
        // }
        // 
        // for mealId in legacyFavorites {
        //     try? await persistenceService.addToFavorites(mealID: mealId)
        // }
        // 
        // // Remove legacy data after successful migration
        // UserDefaults.standard.removeObject(forKey: "WhiskedFavorites")
        // await loadFavorites()
    }
}
