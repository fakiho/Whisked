//
//  PersistenceService.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData

/// Thread-safe ModelActor responsible for managing offline meal data persistence
/// Uses SwiftData for robust local storage with complete meal information
@ModelActor
public actor PersistenceService: PersistenceServiceProtocol {

    // MARK: - Public Methods
    
    /// Saves a meal with complete details to offline storage
    /// - Parameters:
    ///   - idMeal: The unique identifier of the meal
    ///   - strMeal: The name of the meal
    ///   - strMealThumb: The thumbnail image URL
    ///   - strInstructions: The cooking instructions
    ///   - ingredients: Array of ingredient tuples (name, measure)
    /// - Throws: Error if the save operation fails
    public func saveFavoriteMeal(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)]
    ) async throws {
        // Check if meal already exists
        let descriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate { $0.idMeal == idMeal }
        )
        
        let existingMeals = try modelContext.fetch(descriptor)
        
        // Remove existing meal if found (replace strategy)
        for existingMeal in existingMeals {
            modelContext.delete(existingMeal)
        }
        
        // Convert tuple ingredients to Ingredient objects
        let ingredientObjects = ingredients.map { Ingredient(name: $0.name, measure: $0.measure) }
        
        // Create and insert new offline meal
        let offlineMeal = OfflineMeal(
            idMeal: idMeal,
            strMeal: strMeal,
            strMealThumb: strMealThumb,
            strInstructions: strInstructions,
            ingredients: ingredientObjects
        )
        
        modelContext.insert(offlineMeal)
        try modelContext.save()
    }
    
    /// Deletes a meal from offline storage by ID
    /// - Parameter mealID: The unique identifier of the meal to delete
    /// - Throws: Error if the delete operation fails
    public func deleteFavoriteMeal(by idMeal: String) async throws {
        let descriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate { $0.idMeal == idMeal }
        )
        
        let existingMeals = try modelContext.fetch(descriptor)
        
        for meal in existingMeals {
            modelContext.delete(meal)
        }
        
        if !existingMeals.isEmpty {
            try modelContext.save()
        }
    }
    
    /// Fetches a specific offline meal by ID
    /// - Parameter idMeal: The unique identifier of the meal
    /// - Returns: OfflineMealData object if found, nil otherwise
    /// - Throws: Error if the fetch operation fails
    public func fetchFavoriteMeal(by idMeal: String) async throws -> OfflineMealData? {
        let descriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate { $0.idMeal == idMeal }
        )
        
        let meals = try modelContext.fetch(descriptor)
        guard let meal = meals.first else { return nil }
        
        return OfflineMealData(
            idMeal: meal.idMeal,
            strMeal: meal.strMeal,
            strMealThumb: meal.strMealThumb,
            strInstructions: meal.strInstructions,
            ingredients: meal.ingredients,
            dateSaved: meal.dateSaved
        )
    }
    
    /// Retrieves all favorite meal IDs for use in list views
    /// - Returns: A set of meal IDs that are stored offline (favorited)
    /// - Throws: Error if the fetch operation fails
    public func fetchFavoriteIDs() async throws -> Set<String> {
        let descriptor = FetchDescriptor<OfflineMeal>()
        let meals = try modelContext.fetch(descriptor)
        return Set(meals.map { $0.idMeal })
    }
    
    /// Checks if a meal is stored offline (favorited)
    /// - Parameter mealID: The unique identifier of the meal to check
    /// - Returns: True if the meal is stored offline, false otherwise
    /// - Throws: Error if the check operation fails
    public func isFavorite(mealID: String) async throws -> Bool {
        let descriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let count = try modelContext.fetchCount(descriptor)
        return count > 0
    }
    
    /// Retrieves all offline meals sorted by date saved (most recent first)
    /// - Returns: An array of OfflineMealData objects
    /// - Throws: Error if the fetch operation fails
    public func fetchAllOfflineMeals() async throws -> [OfflineMealData] {
        let descriptor = FetchDescriptor<OfflineMeal>(
            sortBy: [SortDescriptor(\.dateSaved, order: .reverse)]
        )
        
        let meals = try modelContext.fetch(descriptor)
        return meals.map { meal in
            OfflineMealData(
                idMeal: meal.idMeal,
                strMeal: meal.strMeal,
                strMealThumb: meal.strMealThumb,
                strInstructions: meal.strInstructions,
                ingredients: meal.ingredients,
                dateSaved: meal.dateSaved
            )
        }
    }
    
    /// Gets the count of offline meals
    /// - Returns: The total number of offline meals
    /// - Throws: Error if the count operation fails
    public func getOfflineMealsCount() async throws -> Int {
        let descriptor = FetchDescriptor<OfflineMeal>()
        return try modelContext.fetchCount(descriptor)
    }
    
    /// Clears all offline meals
    /// - Warning: This operation cannot be undone
    /// - Throws: Error if the clear operation fails
    public func clearAllOfflineMeals() async throws {
        let descriptor = FetchDescriptor<OfflineMeal>()
        let allMeals = try modelContext.fetch(descriptor)
        
        for meal in allMeals {
            modelContext.delete(meal)
        }
        
        if !allMeals.isEmpty {
            try modelContext.save()
        }
    }
}
