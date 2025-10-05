//
//  WhiskedFavoritesService.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData
import Combine

/// Service for managing favorite desserts using SwiftData
@MainActor
final class WhiskedFavoritesService: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = WhiskedFavoritesService()
    
    // MARK: - Properties
    
    @Published private(set) var favorites: Set<String> = []
    
    // MARK: - Initialization
    
    private init() {
        loadFavorites()
    }
    
    // MARK: - Public Methods
    
    /// Checks if a dessert is marked as favorite
    /// - Parameter dessertId: The dessert ID to check
    /// - Returns: True if the dessert is a favorite, false otherwise
    func isFavorite(_ mealId: String) -> Bool {
        favorites.contains(mealId)
    }
    
    /// Toggles the favorite status of a dessert
    /// - Parameter dessertId: The dessert ID to toggle
    func toggleFavorite(_ mealId: String) {
        if favorites.contains(mealId) {
            favorites.remove(mealId)
        } else {
            favorites.insert(mealId)
        }
        saveFavorites()
    }
    
    /// Adds a dessert to favorites
    /// - Parameter dessertId: The dessert ID to add
    func addToFavorites(_ mealId: String) {
        favorites.insert(mealId)
        saveFavorites()
    }
    
    /// Removes a dessert from favorites
    /// - Parameter dessertId: The dessert ID to remove
    func removeFromFavorites(_ mealId: String) {
        favorites.remove(mealId)
        saveFavorites()
    }
    
    // MARK: - Private Methods
    
    /// Loads favorites from UserDefaults
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "WhiskedFavorites"),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            favorites = decoded
        }
    }
    
    /// Saves favorites to UserDefaults
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "WhiskedFavorites")
        }
    }
}
