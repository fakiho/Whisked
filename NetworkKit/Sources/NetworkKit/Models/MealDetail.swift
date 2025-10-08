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
    
    // MARK: - Dynamic Ingredient and Measure Properties
    
    /// Dynamic storage for ingredients (strIngredient1, strIngredient2, etc.)
    public let rawIngredients: [String: String?]
    
    /// Dynamic storage for measures (strMeasure1, strMeasure2, etc.)
    public let rawMeasures: [String: String?]
    
    // MARK: - Initializer
    
    public init(
        idMeal: String,
        strMeal: String,
        strInstructions: String,
        strMealThumb: String,
        rawIngredients: [String: String?] = [:],
        rawMeasures: [String: String?] = [:]
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.rawIngredients = rawIngredients
        self.rawMeasures = rawMeasures
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
        // Extract all valid indices from both ingredients and measures
        let ingredientIndices = Set(rawIngredients.keys.compactMap { extractIndex(from: $0) })
        let measureIndices = Set(rawMeasures.keys.compactMap { extractIndex(from: $0) })
        
        // Get the intersection - only indices that have both ingredient and measure
        let validIndices = ingredientIndices.intersection(measureIndices).sorted()
        
        var ingredientList: [Ingredient] = []
        
        for index in validIndices {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            // Safe access to dictionary values
            guard let ingredientValue = rawIngredients[ingredientKey],
                  let measureValue = rawMeasures[measureKey],
                  let ingredientName = ingredientValue?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !ingredientName.isEmpty,
                  let measure = measureValue?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !measure.isEmpty else {
                continue
            }
            
            ingredientList.append(Ingredient(name: ingredientName, measure: measure))
        }
        
        return ingredientList
    }
    
    /// Helper method to extract numeric index from ingredient/measure key
    /// Returns nil for malformed keys (e.g., "strIngredient" without number)
    private func extractIndex(from key: String) -> Int? {
        if key.hasPrefix("strIngredient") {
            let numberPart = key.dropFirst("strIngredient".count)
            return numberPart.isEmpty ? nil : Int(numberPart)
        } else if key.hasPrefix("strMeasure") {
            let numberPart = key.dropFirst("strMeasure".count)
            return numberPart.isEmpty ? nil : Int(numberPart)
        }
        return nil
    }
}

// MARK: - Custom Codable Implementation

extension MealDetail {
    
    /// Custom decoder to handle dynamic ingredient/measure parsing
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Decode core properties safely - provide fallback behavior if keys can't be created
        if let idMealKey = DynamicCodingKeys.idMeal {
            self.idMeal = try container.decode(String.self, forKey: idMealKey)
        } else {
            // If we can't create the key, provide a default value or throw a proper error
            self.idMeal = ""
        }
        
        if let strMealKey = DynamicCodingKeys.strMeal {
            self.strMeal = try container.decode(String.self, forKey: strMealKey)
        } else {
            self.strMeal = ""
        }
        
        if let strInstructionsKey = DynamicCodingKeys.strInstructions {
            self.strInstructions = try container.decode(String.self, forKey: strInstructionsKey)
        } else {
            self.strInstructions = ""
        }
        
        if let strMealThumbKey = DynamicCodingKeys.strMealThumb {
            self.strMealThumb = try container.decode(String.self, forKey: strMealThumbKey)
        } else {
            self.strMealThumb = ""
        }
        
        // Dynamically decode ingredients and measures
        var ingredients: [String: String?] = [:]
        var measures: [String: String?] = [:]
        
        for key in container.allKeys {
            if key.stringValue.hasPrefix("strIngredient") {
                ingredients[key.stringValue] = try container.decodeIfPresent(String.self, forKey: key)
            } else if key.stringValue.hasPrefix("strMeasure") {
                measures[key.stringValue] = try container.decodeIfPresent(String.self, forKey: key)
            }
        }
        
        self.rawIngredients = ingredients
        self.rawMeasures = measures
    }
    
    /// Custom encoder to handle dynamic ingredient/measure encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Encode core properties safely - skip if keys can't be created
        if let idMealKey = DynamicCodingKeys.idMeal {
            try container.encode(idMeal, forKey: idMealKey)
        }
        
        if let strMealKey = DynamicCodingKeys.strMeal {
            try container.encode(strMeal, forKey: strMealKey)
        }
        
        if let strInstructionsKey = DynamicCodingKeys.strInstructions {
            try container.encode(strInstructions, forKey: strInstructionsKey)
        }
        
        if let strMealThumbKey = DynamicCodingKeys.strMealThumb {
            try container.encode(strMealThumb, forKey: strMealThumbKey)
        }
        
        // Encode ingredients dynamically - skip if key creation fails
        for (key, value) in rawIngredients {
            if let codingKey = DynamicCodingKeys.makeSafe(stringValue: key) {
                try container.encodeIfPresent(value, forKey: codingKey)
            }
            // If key creation fails, silently skip this ingredient
        }
        
        // Encode measures dynamically - skip if key creation fails
        for (key, value) in rawMeasures {
            if let codingKey = DynamicCodingKeys.makeSafe(stringValue: key) {
                try container.encodeIfPresent(value, forKey: codingKey)
            }
            // If key creation fails, silently skip this measure
        }
    }
    
    /// Dynamic coding keys to handle variable ingredient/measure fields
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
        
        // MARK: - Completely Safe Keys for Core Properties (Zero Force Unwrapping!)
        
        static var idMeal: DynamicCodingKeys? {
            DynamicCodingKeys(stringValue: "idMeal")
        }
        
        static var strMeal: DynamicCodingKeys? {
            DynamicCodingKeys(stringValue: "strMeal")
        }
        
        static var strInstructions: DynamicCodingKeys? {
            DynamicCodingKeys(stringValue: "strInstructions")
        }
        
        static var strMealThumb: DynamicCodingKeys? {
            DynamicCodingKeys(stringValue: "strMealThumb")
        }
        
        // MARK: - Completely Safe Factory Method
        
        /// Creates a DynamicCodingKeys instance safely, returns nil if creation fails
        static func makeSafe(stringValue: String) -> DynamicCodingKeys? {
            return DynamicCodingKeys(stringValue: stringValue)
        }
        
        /// Ultimate fallback initializer that cannot fail
        private init(fallbackKey: String) {
            self.stringValue = fallbackKey
            self.intValue = nil
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
    public let meals: [MealDetail]?
    
    public init(meals: [MealDetail]?) {
        self.meals = meals
    }
}