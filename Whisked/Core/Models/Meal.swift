//
//  Meal.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Model representing a meal from TheMealDB API dessert list endpoint
struct Meal: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    // MARK: - Computed Properties
    
    /// Convenience property for accessing the meal ID
    var id: String { idMeal }
    
    /// Convenience property for accessing the meal name
    var name: String { strMeal }
    
    /// Convenience property for accessing the meal thumbnail URL
    var thumbnailURL: String { strMealThumb }
}

// MARK: - API Response Container

/// Container for the API response containing an array of meals
struct MealsResponse: Codable, Sendable {
    let meals: [Meal]
}