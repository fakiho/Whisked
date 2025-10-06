//
//  Meal.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Model representing a meal from TheMealDB API meal list endpoint
public struct Meal: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let idMeal: String
    public let strMeal: String
    public let strMealThumb: String
    
    // MARK: - Initializer
    
    public init(idMeal: String, strMeal: String, strMealThumb: String) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
    }
    
    // MARK: - Computed Properties
    
    /// Convenience property for accessing the meal ID
    public var id: String { idMeal }
    
    /// Convenience property for accessing the meal name
    public var name: String { strMeal }
    
    /// Convenience property for accessing the meal thumbnail URL
    public var thumbnailURL: String { strMealThumb }
}

// MARK: - API Response Container

/// Container for the API response containing an array of meals
public struct MealsResponse: Codable, Sendable {
    public let meals: [Meal]
    
    public init(meals: [Meal]) {
        self.meals = meals
    }
}