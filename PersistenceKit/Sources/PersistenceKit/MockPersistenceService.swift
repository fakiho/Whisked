//
//  MockPersistenceService.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation

/// Mock persistence service that provides graceful fallback behavior
/// when SwiftData container initialization fails
public final class MockPersistenceService: PersistenceServiceProtocol, @unchecked Sendable {
    
    // MARK: - Properties
    
    /// In-memory storage for favorite meal IDs when SwiftData is unavailable
    private var favoriteIDs: Set<String> = []
    
    /// In-memory storage for offline meal data when SwiftData is unavailable
    private var offlineMeals: [String: OfflineMealData] = [:]
    
    // MARK: - Initialization
    
    /// Public initializer for creating mock persistence service
    public init() {
        // Initialize empty in-memory storage
    }
    
    // MARK: - Public Methods
    
    /// Saves a meal with complete details to in-memory storage
    /// - Parameters:
    ///   - idMeal: The unique identifier of the meal
    ///   - strMeal: The name of the meal
    ///   - strMealThumb: The thumbnail image URL
    ///   - strInstructions: The cooking instructions
    ///   - ingredients: Array of ingredient tuples (name, measure)
    /// - Note: This is a fallback implementation that doesn't persist across app launches
    public func saveFavoriteMeal(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)]
    ) async throws {
        favoriteIDs.insert(idMeal)
        
        let ingredientObjects = ingredients.map { Ingredient(name: $0.name, measure: $0.measure) }
        let offlineMealData = OfflineMealData(
            idMeal: idMeal,
            strMeal: strMeal,
            strMealThumb: strMealThumb,
            strInstructions: strInstructions,
            ingredients: ingredientObjects,
            dateSaved: Date()
        )
        
        offlineMeals[idMeal] = offlineMealData
    }
    
    /// Deletes a meal from in-memory storage by ID
    /// - Parameter mealID: The unique identifier of the meal to delete
    public func deleteFavoriteMeal(by idMeal: String) async throws {
        favoriteIDs.remove(idMeal)
        offlineMeals.removeValue(forKey: idMeal)
    }
    
    /// Fetches a specific offline meal by ID from in-memory storage
    /// - Parameter idMeal: The unique identifier of the meal
    /// - Returns: OfflineMealData object if found, nil otherwise
    public func fetchFavoriteMeal(by idMeal: String) async throws -> OfflineMealData? {
        return offlineMeals[idMeal]
    }
    
    /// Retrieves all favorite meal IDs from in-memory storage
    /// - Returns: A set of meal IDs that are stored in memory (favorited)
    public func fetchFavoriteIDs() async throws -> Set<String> {
        return favoriteIDs
    }
    
    /// Checks if a meal is stored in memory (favorited)
    /// - Parameter mealID: The unique identifier of the meal to check
    /// - Returns: True if the meal is stored in memory, false otherwise
    public func isFavorite(mealID: String) async throws -> Bool {
        return favoriteIDs.contains(mealID)
    }
    
    /// Retrieves all offline meals from in-memory storage sorted by date saved
    /// - Returns: An array of OfflineMealData objects
    public func fetchAllOfflineMeals() async throws -> [OfflineMealData] {
        return Array(offlineMeals.values).sorted { $0.dateSaved > $1.dateSaved }
    }
    
    /// Gets the count of offline meals in memory
    /// - Returns: The total number of offline meals
    public func getOfflineMealsCount() async throws -> Int {
        return offlineMeals.count
    }
    
    /// Clears all offline meals from memory
    /// - Warning: This operation cannot be undone
    public func clearAllOfflineMeals() async throws {
        favoriteIDs.removeAll()
        offlineMeals.removeAll()
    }
}