//
//  PersistenceService.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData

/// Actor-based service for managing offline meals persistence using SwiftData
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
    
    /// Saves a meal with complete details to offline storage
    /// - Parameters:
    ///   - idMeal: The unique identifier of the meal
    ///   - strMeal: The name of the meal
    ///   - strMealThumb: The thumbnail image URL
    ///   - strInstructions: The cooking instructions
    ///   - ingredients: Array of ingredient tuples (name, measure)
    /// - Throws: Error if the save operation fails
    public func save(
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
    public func delete(mealID: String) async throws {
        let descriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let existingMeals = try modelContext.fetch(descriptor)
        
        for meal in existingMeals {
            modelContext.delete(meal)
        }
        
        if !existingMeals.isEmpty {
            try modelContext.save()
        }
    }
    
    /// Fetches a specific meal from offline storage
    /// - Parameter mealID: The unique identifier of the meal to fetch
    /// - Returns: A tuple containing the meal data if found, nil otherwise
    /// - Throws: Error if the fetch operation fails
    public func fetch(mealID: String) async throws -> (
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)]
    )? {
        let descriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate { $0.idMeal == mealID }
        )
        
        let meals = try modelContext.fetch(descriptor)
        guard let meal = meals.first else { return nil }
        
        let ingredientTuples = meal.ingredients.map { ($0.name, $0.measure) }
        
        return (
            idMeal: meal.idMeal,
            strMeal: meal.strMeal,
            strMealThumb: meal.strMealThumb,
            strInstructions: meal.strInstructions,
            ingredients: ingredientTuples
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
    /// - Returns: An array of tuples containing all offline meal data
    /// - Throws: Error if the fetch operation fails
    public func fetchAllOfflineMeals() async throws -> [(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)],
        dateSaved: Date
    )] {
        let descriptor = FetchDescriptor<OfflineMeal>(
            sortBy: [SortDescriptor(\.dateSaved, order: .reverse)]
        )
        
        let meals = try modelContext.fetch(descriptor)
        return meals.map { meal in
            let ingredientTuples = meal.ingredients.map { ($0.name, $0.measure) }
            return (
                idMeal: meal.idMeal,
                strMeal: meal.strMeal,
                strMealThumb: meal.strMealThumb,
                strInstructions: meal.strInstructions,
                ingredients: ingredientTuples,
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