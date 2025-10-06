//
//  OfflineMeal.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData

/// Model representing a recipe ingredient with its measurement
public struct Ingredient: Identifiable, Codable, Hashable, Sendable {
    public let name: String
    public let measure: String
    
    /// Unique identifier for the ingredient
    public var id: String { "\(name)-\(measure)" }
    
    /// Formatted display string combining measure and name
    public var displayText: String {
        "\(measure) \(name)"
    }
    
    public init(name: String, measure: String) {
        self.name = name
        self.measure = measure
    }
}

/// Sendable data transfer object for OfflineMeal
public struct OfflineMealData: Identifiable, Sendable {
    public let idMeal: String
    public let strMeal: String
    public let strMealThumb: String
    public let strInstructions: String
    public let ingredients: [Ingredient]
    public let dateSaved: Date
    
    public var id: String { idMeal }
    
    public init(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [Ingredient],
        dateSaved: Date
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.strInstructions = strInstructions
        self.ingredients = ingredients
        self.dateSaved = dateSaved
    }
}

/// SwiftData model representing a complete offline meal with all recipe details
@Model
public final class OfflineMeal {
    
    /// Unique identifier for the meal
    @Attribute(.unique) public var idMeal: String
    
    /// Name of the meal
    public var strMeal: String
    
    /// Thumbnail image URL
    public var strMealThumb: String
    
    /// Cooking instructions
    public var strInstructions: String
    
    /// List of ingredients with their measurements
    public var ingredients: [Ingredient]
    
    /// Date when the meal was saved offline
    public var dateSaved: Date
    
    /// Initializes a new offline meal
    /// - Parameters:
    ///   - idMeal: The unique identifier of the meal
    ///   - strMeal: The name of the meal
    ///   - strMealThumb: The thumbnail image URL
    ///   - strInstructions: The cooking instructions
    ///   - ingredients: Array of ingredients with measurements
    ///   - dateSaved: The date when the meal was saved (defaults to current date)
    public init(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [Ingredient],
        dateSaved: Date = Date()
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.strInstructions = strInstructions
        self.ingredients = ingredients
        self.dateSaved = dateSaved
    }
}

// MARK: - Comparable

extension OfflineMeal: Comparable {
    public static func < (lhs: OfflineMeal, rhs: OfflineMeal) -> Bool {
        lhs.dateSaved < rhs.dateSaved
    }
}

// MARK: - Identifiable

extension OfflineMeal: Identifiable {
    public var id: String { idMeal }
}