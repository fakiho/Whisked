//
//  MealDetail+PersistenceKit.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

// MARK: - Protocol Extensions for Mapping

/// Extension to handle conversion from app's Ingredient to PersistenceKit Ingredient
extension Ingredient {
    /// Converts Whisked.Ingredient to PersistenceKit.Ingredient format
    /// - Returns: A tuple with name and measure
    func toPersistenceFormat() -> (name: String, measure: String) {
        return (name: self.name, measure: self.measure)
    }
    
    /// Creates a Whisked.Ingredient from PersistenceKit ingredient data
    /// - Parameters:
    ///   - name: The ingredient name
    ///   - measure: The ingredient measure
    /// - Returns: A Whisked.Ingredient instance
    static func fromPersistenceFormat(name: String, measure: String) -> Ingredient {
        return Ingredient(name: name, measure: measure)
    }
}

// MARK: - MealDetail Data Extraction

extension MealDetail {
    /// Extracts essential data for offline storage
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
            idMeal: self.idMeal,
            strMeal: self.strMeal,
            strMealThumb: self.strMealThumb,
            strInstructions: self.strInstructions,
            ingredients: persistenceIngredients
        )
    }
    
    /// Creates a MealDetail from offline meal data
    /// - Parameters:
    ///   - idMeal: The meal ID
    ///   - strMeal: The meal name
    ///   - strMealThumb: The meal thumbnail URL
    ///   - strInstructions: The cooking instructions
    ///   - ingredients: Array of ingredient tuples
    /// - Returns: A complete MealDetail instance
    static func fromOfflineData(
        idMeal: String,
        strMeal: String,
        strMealThumb: String,
        strInstructions: String,
        ingredients: [(name: String, measure: String)]
    ) -> MealDetail {
        // Convert ingredients back to individual fields as expected by MealDetail
        var ingredientFields: [String?] = Array(repeating: nil, count: 20)
        var measureFields: [String?] = Array(repeating: nil, count: 20)
        
        for (index, ingredient) in ingredients.enumerated() {
            if index < 20 {
                ingredientFields[index] = ingredient.name
                measureFields[index] = ingredient.measure
            }
        }
        
        return MealDetail(
            idMeal: idMeal,
            strMeal: strMeal,
            strInstructions: strInstructions,
            strMealThumb: strMealThumb,
            strIngredient1: ingredientFields[0],
            strIngredient2: ingredientFields[1],
            strIngredient3: ingredientFields[2],
            strIngredient4: ingredientFields[3],
            strIngredient5: ingredientFields[4],
            strIngredient6: ingredientFields[5],
            strIngredient7: ingredientFields[6],
            strIngredient8: ingredientFields[7],
            strIngredient9: ingredientFields[8],
            strIngredient10: ingredientFields[9],
            strIngredient11: ingredientFields[10],
            strIngredient12: ingredientFields[11],
            strIngredient13: ingredientFields[12],
            strIngredient14: ingredientFields[13],
            strIngredient15: ingredientFields[14],
            strIngredient16: ingredientFields[15],
            strIngredient17: ingredientFields[16],
            strIngredient18: ingredientFields[17],
            strIngredient19: ingredientFields[18],
            strIngredient20: ingredientFields[19],
            strMeasure1: measureFields[0],
            strMeasure2: measureFields[1],
            strMeasure3: measureFields[2],
            strMeasure4: measureFields[3],
            strMeasure5: measureFields[4],
            strMeasure6: measureFields[5],
            strMeasure7: measureFields[6],
            strMeasure8: measureFields[7],
            strMeasure9: measureFields[8],
            strMeasure10: measureFields[9],
            strMeasure11: measureFields[10],
            strMeasure12: measureFields[11],
            strMeasure13: measureFields[12],
            strMeasure14: measureFields[13],
            strMeasure15: measureFields[14],
            strMeasure16: measureFields[15],
            strMeasure17: measureFields[16],
            strMeasure18: measureFields[17],
            strMeasure19: measureFields[18],
            strMeasure20: measureFields[19]
        )
    }
}