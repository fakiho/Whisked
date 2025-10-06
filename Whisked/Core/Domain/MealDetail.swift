//
//  MealDetail.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Domain model representing detailed meal information for the consumer layer
public struct MealDetail: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let id: String
    public let name: String
    public let instructions: String
    public let thumbnailURL: String
    public let ingredients: [Ingredient]
    
    // MARK: - Initializer
    
    public init(id: String, name: String, instructions: String, thumbnailURL: String, ingredients: [Ingredient]) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.thumbnailURL = thumbnailURL
        self.ingredients = ingredients
    }
}

// MARK: - Ingredient Model

/// Domain model representing a recipe ingredient with its measurement
public struct Ingredient: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let name: String
    public let measure: String
    
    // MARK: - Initializer
    
    public init(name: String, measure: String) {
        self.name = name
        self.measure = measure
    }
    
    // MARK: - Computed Properties
    
    /// Unique identifier for the ingredient
    public var id: String { "\(name)-\(measure)" }
    
    /// Formatted display string combining measure and name
    public var displayText: String {
        "\(measure) \(name)"
    }
}

