//
//  MealDetail.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Model representing detailed meal information from TheMealDB API lookup endpoint
public struct MealDetail: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Core Properties
    
    public let idMeal: String
    public let strMeal: String
    public let strInstructions: String
    public let strMealThumb: String
    
    // MARK: - Ingredient Properties (Raw from API)
    
    public let strIngredient1: String?
    public let strIngredient2: String?
    public let strIngredient3: String?
    public let strIngredient4: String?
    public let strIngredient5: String?
    public let strIngredient6: String?
    public let strIngredient7: String?
    public let strIngredient8: String?
    public let strIngredient9: String?
    public let strIngredient10: String?
    public let strIngredient11: String?
    public let strIngredient12: String?
    public let strIngredient13: String?
    public let strIngredient14: String?
    public let strIngredient15: String?
    public let strIngredient16: String?
    public let strIngredient17: String?
    public let strIngredient18: String?
    public let strIngredient19: String?
    public let strIngredient20: String?
    
    // MARK: - Measure Properties (Raw from API)
    
    public let strMeasure1: String?
    public let strMeasure2: String?
    public let strMeasure3: String?
    public let strMeasure4: String?
    public let strMeasure5: String?
    public let strMeasure6: String?
    public let strMeasure7: String?
    public let strMeasure8: String?
    public let strMeasure9: String?
    public let strMeasure10: String?
    public let strMeasure11: String?
    public let strMeasure12: String?
    public let strMeasure13: String?
    public let strMeasure14: String?
    public let strMeasure15: String?
    public let strMeasure16: String?
    public let strMeasure17: String?
    public let strMeasure18: String?
    public let strMeasure19: String?
    public let strMeasure20: String?
    
    // MARK: - Initializer
    
    public init(
        idMeal: String,
        strMeal: String,
        strInstructions: String,
        strMealThumb: String,
        strIngredient1: String? = nil,
        strIngredient2: String? = nil,
        strIngredient3: String? = nil,
        strIngredient4: String? = nil,
        strIngredient5: String? = nil,
        strIngredient6: String? = nil,
        strIngredient7: String? = nil,
        strIngredient8: String? = nil,
        strIngredient9: String? = nil,
        strIngredient10: String? = nil,
        strIngredient11: String? = nil,
        strIngredient12: String? = nil,
        strIngredient13: String? = nil,
        strIngredient14: String? = nil,
        strIngredient15: String? = nil,
        strIngredient16: String? = nil,
        strIngredient17: String? = nil,
        strIngredient18: String? = nil,
        strIngredient19: String? = nil,
        strIngredient20: String? = nil,
        strMeasure1: String? = nil,
        strMeasure2: String? = nil,
        strMeasure3: String? = nil,
        strMeasure4: String? = nil,
        strMeasure5: String? = nil,
        strMeasure6: String? = nil,
        strMeasure7: String? = nil,
        strMeasure8: String? = nil,
        strMeasure9: String? = nil,
        strMeasure10: String? = nil,
        strMeasure11: String? = nil,
        strMeasure12: String? = nil,
        strMeasure13: String? = nil,
        strMeasure14: String? = nil,
        strMeasure15: String? = nil,
        strMeasure16: String? = nil,
        strMeasure17: String? = nil,
        strMeasure18: String? = nil,
        strMeasure19: String? = nil,
        strMeasure20: String? = nil
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.strIngredient1 = strIngredient1
        self.strIngredient2 = strIngredient2
        self.strIngredient3 = strIngredient3
        self.strIngredient4 = strIngredient4
        self.strIngredient5 = strIngredient5
        self.strIngredient6 = strIngredient6
        self.strIngredient7 = strIngredient7
        self.strIngredient8 = strIngredient8
        self.strIngredient9 = strIngredient9
        self.strIngredient10 = strIngredient10
        self.strIngredient11 = strIngredient11
        self.strIngredient12 = strIngredient12
        self.strIngredient13 = strIngredient13
        self.strIngredient14 = strIngredient14
        self.strIngredient15 = strIngredient15
        self.strIngredient16 = strIngredient16
        self.strIngredient17 = strIngredient17
        self.strIngredient18 = strIngredient18
        self.strIngredient19 = strIngredient19
        self.strIngredient20 = strIngredient20
        self.strMeasure1 = strMeasure1
        self.strMeasure2 = strMeasure2
        self.strMeasure3 = strMeasure3
        self.strMeasure4 = strMeasure4
        self.strMeasure5 = strMeasure5
        self.strMeasure6 = strMeasure6
        self.strMeasure7 = strMeasure7
        self.strMeasure8 = strMeasure8
        self.strMeasure9 = strMeasure9
        self.strMeasure10 = strMeasure10
        self.strMeasure11 = strMeasure11
        self.strMeasure12 = strMeasure12
        self.strMeasure13 = strMeasure13
        self.strMeasure14 = strMeasure14
        self.strMeasure15 = strMeasure15
        self.strMeasure16 = strMeasure16
        self.strMeasure17 = strMeasure17
        self.strMeasure18 = strMeasure18
        self.strMeasure19 = strMeasure19
        self.strMeasure20 = strMeasure20
    }
    
    // MARK: - Computed Properties
    
    /// Convenience property for accessing the meal ID
    public var id: String { idMeal }
    
    /// Convenience property for accessing the meal name
    public var name: String { strMeal }
    
    /// Convenience property for accessing the meal instructions
    public var instructions: String { strInstructions }
    
    /// Convenience property for accessing the meal thumbnail URL
    public var thumbnailURL: String { strMealThumb }
    
    /// Intelligently parsed ingredients and measures as a clean array
    public var ingredients: [Ingredient] {
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
public struct Ingredient: Identifiable, Codable, Hashable, Sendable {
    public let name: String
    public let measure: String
    
    // MARK: - Initializer
    
    public init(name: String, measure: String) {
        self.name = name
        self.measure = measure
    }
    
    /// Unique identifier for the ingredient
    public var id: String { "\(name)-\(measure)" }
    
    /// Formatted display string combining measure and name
    public var displayText: String {
        "\(measure) \(name)"
    }
}

// MARK: - API Response Container

/// Container for the API response containing an array of meal details
public struct MealDetailResponse: Codable, Sendable {
    public let meals: [MealDetail]
    
    public init(meals: [MealDetail]) {
        self.meals = meals
    }
}