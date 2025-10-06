//
//  MealDetail+PersistenceKit.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

// MARK: - Extensions for PersistenceKit Integration

/// Extension to handle conversion from domain Ingredient to PersistenceKit format
extension Ingredient {
    /// Converts domain Ingredient to PersistenceKit format
    /// - Returns: A tuple with name and measure for PersistenceKit storage
    func toPersistenceFormat() -> (name: String, measure: String) {
        return (name: self.name, measure: self.measure)
    }
    
    /// Creates a domain Ingredient from PersistenceKit ingredient data
    /// - Parameters:
    ///   - name: The ingredient name
    ///   - measure: The ingredient measure
    /// - Returns: A domain Ingredient instance
    static func fromPersistenceFormat(name: String, measure: String) -> Ingredient {
        return Ingredient(name: name, measure: measure)
    }
}

// MARK: - MealDetail PersistenceKit Integration

extension MealDetail {
    /// Extracts essential data for offline storage in PersistenceKit format
    /// - Returns: A tuple containing all necessary data for offline meal storage
    func extractForOfflineStorage() -> (
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)]
    ) {
        let persistenceIngredients = self.ingredients.map { ingredient in
            ingredient.toPersistenceFormat()
        }
        
        return (
            idMeal: self.id,
            strMeal: self.name,
            strMealThumb: self.thumbnailURL,
            strInstructions: self.instructions,
            ingredients: persistenceIngredients
        )
    }
    
    /// Creates a domain MealDetail from offline meal data stored in PersistenceKit
    /// - Parameters:
    ///   - idMeal: The meal ID
    ///   - strMeal: The meal name
    ///   - strMealThumb: The meal thumbnail URL
    ///   - strInstructions: The cooking instructions
    ///   - ingredients: Array of ingredient tuples from PersistenceKit
    /// - Returns: A complete domain MealDetail instance
    static func fromOfflineData(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)]
    ) -> MealDetail {
        // Convert PersistenceKit ingredient tuples to domain Ingredient objects
        let domainIngredients = ingredients.map { ingredientTuple in
            Ingredient.fromPersistenceFormat(name: ingredientTuple.name, measure: ingredientTuple.measure)
        }
        
        // Create domain MealDetail using the clean constructor
        return MealDetail(
            id: idMeal,
            name: strMeal,
            instructions: strInstructions,
            thumbnailURL: strMealThumb,
            ingredients: domainIngredients
        )
    }
}
