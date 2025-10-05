//
//  WhiskedMeal.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Model representing a meal from TheMealDB API
struct WhiskedMeal: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let thumbnailURL: String
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}

/// Model representing detailed information about a meal
struct WhiskedMealDetail: Identifiable, Codable, Sendable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let instructions: String
    let thumbnailURL: String
    let ingredients: [WhiskedIngredient]
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        // Ingredients are handled separately due to the API structure
    }
    
    // MARK: - Custom Decoding
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        
        // Parse ingredients from the flat structure
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var parsedIngredients: [WhiskedIngredient] = []
        
        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try? dynamicContainer.decode(String.self, forKey: ingredientKey),
               let measure = try? dynamicContainer.decode(String.self, forKey: measureKey),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                parsedIngredients.append(WhiskedIngredient(name: ingredient, measure: measure))
            }
        }
        
        ingredients = parsedIngredients
    }
}

/// Model representing an ingredient with its measure
struct WhiskedIngredient: Identifiable, Codable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let measure: String
    
    enum CodingKeys: String, CodingKey {
        case name, measure
    }
}

/// Dynamic coding keys for parsing the flat ingredient structure from the API
struct DynamicCodingKeys: CodingKey, Sendable {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}
