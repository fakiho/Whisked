//
//  MealDetail.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Model representing detailed meal information from TheMealDB API lookup endpoint
struct MealDetail: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Core Properties
    
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    
    // MARK: - Ingredient Properties (Raw from API)
    
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    
    // MARK: - Measure Properties (Raw from API)
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    
    // MARK: - Computed Properties
    
    /// Convenience property for accessing the meal ID
    var id: String { idMeal }
    
    /// Convenience property for accessing the meal name
    var name: String { strMeal }
    
    /// Convenience property for accessing the meal instructions
    var instructions: String { strInstructions }
    
    /// Convenience property for accessing the meal thumbnail URL
    var thumbnailURL: String { strMealThumb }
    
    /// Intelligently parsed ingredients and measures as a clean array
    var ingredients: [Ingredient] {
        let ingredientPairs = [
            (strIngredient1, strMeasure1),
            (strIngredient2, strMeasure2),
            (strIngredient3, strMeasure3),
            (strIngredient4, strMeasure4),
            (strIngredient5, strMeasure5),
            (strIngredient6, strMeasure6),
            (strIngredient7, strMeasure7),
            (strIngredient8, strMeasure8),
            (strIngredient9, strMeasure9),
            (strIngredient10, strMeasure10),
            (strIngredient11, strMeasure11),
            (strIngredient12, strMeasure12),
            (strIngredient13, strMeasure13),
            (strIngredient14, strMeasure14),
            (strIngredient15, strMeasure15),
            (strIngredient16, strMeasure16),
            (strIngredient17, strMeasure17),
            (strIngredient18, strMeasure18),
            (strIngredient19, strMeasure19),
            (strIngredient20, strMeasure20)
        ]
        
        return ingredientPairs.compactMap { ingredientName, measure in
            guard let ingredientName = ingredientName?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !ingredientName.isEmpty,
                  let measure = measure?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !measure.isEmpty else {
                return nil
            }
            return Ingredient(name: ingredientName, measure: measure)
        }
    }
}

// MARK: - Ingredient Model

/// Model representing a recipe ingredient with its measurement
struct Ingredient: Identifiable, Codable, Hashable, Sendable {
    let name: String
    let measure: String
    
    /// Unique identifier for the ingredient
    var id: String { "\(name)-\(measure)" }
    
    /// Formatted display string combining measure and name
    var displayText: String {
        "\(measure) \(name)"
    }
}

// MARK: - API Response Container

/// Container for the API response containing an array of meal details
struct MealDetailResponse: Codable, Sendable {
    let meals: [MealDetail]
}