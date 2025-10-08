//
//  MealDetailTests.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//

import Testing
import Foundation
@testable import NetworkKit

@Suite("MealDetail Dynamic Parsing Tests")
struct MealDetailTests {
    
    // MARK: - Test Data
    
    /// Sample JSON representing a typical API response with standard ingredients
    private var standardMealJSON: String {
        """
        {
            "idMeal": "52768",
            "strMeal": "Apple Frangipane Tart",
            "strInstructions": "Preheat the oven to 200C/180C Fan/Gas 6...",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            "strIngredient1": "digestive biscuits",
            "strIngredient2": "butter",
            "strIngredient3": "Bramley apples",
            "strIngredient4": "butter, softened",
            "strIngredient5": "caster sugar",
            "strIngredient6": "free-range eggs, beaten",
            "strIngredient7": "ground almonds",
            "strIngredient8": "almond extract",
            "strIngredient9": "flaked almonds",
            "strIngredient10": "",
            "strIngredient11": "",
            "strIngredient12": "",
            "strIngredient13": "",
            "strIngredient14": "",
            "strIngredient15": "",
            "strIngredient16": "",
            "strIngredient17": "",
            "strIngredient18": "",
            "strIngredient19": "",
            "strIngredient20": "",
            "strMeasure1": "175g",
            "strMeasure2": "75g",
            "strMeasure3": "200g",
            "strMeasure4": "75g",
            "strMeasure5": "75g",
            "strMeasure6": "2",
            "strMeasure7": "75g",
            "strMeasure8": "1/2 teaspoon",
            "strMeasure9": "50g",
            "strMeasure10": "",
            "strMeasure11": "",
            "strMeasure12": "",
            "strMeasure13": "",
            "strMeasure14": "",
            "strMeasure15": "",
            "strMeasure16": "",
            "strMeasure17": "",
            "strMeasure18": "",
            "strMeasure19": "",
            "strMeasure20": ""
        }
        """
    }
    
    /// Sample JSON with extra ingredients beyond the typical 20
    private var extendedMealJSON: String {
        """
        {
            "idMeal": "52999",
            "strMeal": "Extended Recipe",
            "strInstructions": "A recipe with many ingredients...",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "flour",
            "strIngredient2": "sugar",
            "strIngredient21": "vanilla extract",
            "strIngredient22": "chocolate chips",
            "strIngredient25": "salt",
            "strMeasure1": "2 cups",
            "strMeasure2": "1 cup",
            "strMeasure21": "1 tsp",
            "strMeasure22": "1/2 cup",
            "strMeasure25": "1/4 tsp"
        }
        """
    }
    
    /// Sample JSON with malformed keys (missing indices)
    private var malformedMealJSON: String {
        """
        {
            "idMeal": "52888",
            "strMeal": "Malformed Recipe",
            "strInstructions": "A recipe with malformed data...",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "valid ingredient",
            "strIngredient": "malformed ingredient without number",
            "strIngredient3": "another valid ingredient",
            "strMeasure1": "1 cup",
            "strMeasure": "malformed measure without number",
            "strMeasure3": "2 cups"
        }
        """
    }
    
    /// Sample JSON with missing measures for some ingredients
    private var incompleteMealJSON: String {
        """
        {
            "idMeal": "52777",
            "strMeal": "Incomplete Recipe",
            "strInstructions": "A recipe with missing measures...",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "ingredient with measure",
            "strIngredient2": "ingredient without measure",
            "strIngredient3": "another ingredient with measure",
            "strMeasure1": "1 cup",
            "strMeasure3": "2 tbsp"
        }
        """
    }
    
    // MARK: - Core Functionality Tests
    
    @Test("MealDetail decodes standard JSON correctly")
    func standardMealDecoding() throws {
        let jsonData = standardMealJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        // Verify core properties
        #expect(mealDetail.idMeal == "52768")
        #expect(mealDetail.strMeal == "Apple Frangipane Tart")
        #expect(mealDetail.strInstructions == "Preheat the oven to 200C/180C Fan/Gas 6...")
        #expect(mealDetail.strMealThumb == "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
        
        // Verify convenience properties
        #expect(mealDetail.id == "52768")
        #expect(mealDetail.name == "Apple Frangipane Tart")
        #expect(mealDetail.instructions == "Preheat the oven to 200C/180C Fan/Gas 6...")
        #expect(mealDetail.thumbnailURL == "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
        
        // Verify dynamic storage
        #expect(mealDetail.rawIngredients.count >= 9) // We have 9 non-empty ingredients
        #expect(mealDetail.rawMeasures.count >= 9) // We have 9 non-empty measures
        
        // Verify specific ingredient storage
        #expect(mealDetail.rawIngredients["strIngredient1"] == "digestive biscuits")
        #expect(mealDetail.rawMeasures["strMeasure1"] == "175g")
    }
    
    @Test("MealDetail processes ingredients correctly")
    func ingredientsProcessing() throws {
        let jsonData = standardMealJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        let ingredients = mealDetail.ingredients
        
        // Should have 9 valid ingredients (non-empty pairs)
        #expect(ingredients.count == 9)
        
        // Verify specific ingredients
        let expectedIngredients = [
            ("digestive biscuits", "175g"),
            ("butter", "75g"),
            ("Bramley apples", "200g"),
            ("butter, softened", "75g"),
            ("caster sugar", "75g"),
            ("free-range eggs, beaten", "2"),
            ("ground almonds", "75g"),
            ("almond extract", "1/2 teaspoon"),
            ("flaked almonds", "50g")
        ]
        
        for (index, expected) in expectedIngredients.enumerated() {
            #expect(ingredients[index].name == expected.0)
            #expect(ingredients[index].measure == expected.1)
            #expect(ingredients[index].displayText == "\(expected.1) \(expected.0)")
        }
    }
    
    @Test("MealDetail handles extended ingredients beyond 20")
    func extendedIngredientsDecoding() throws {
        let jsonData = extendedMealJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        // Verify dynamic storage includes extended ingredients
        #expect(mealDetail.rawIngredients["strIngredient21"] == "vanilla extract")
        #expect(mealDetail.rawIngredients["strIngredient22"] == "chocolate chips")
        #expect(mealDetail.rawIngredients["strIngredient25"] == "salt")
        
        #expect(mealDetail.rawMeasures["strMeasure21"] == "1 tsp")
        #expect(mealDetail.rawMeasures["strMeasure22"] == "1/2 cup")
        #expect(mealDetail.rawMeasures["strMeasure25"] == "1/4 tsp")
        
        // Verify processed ingredients include extended ones
        let ingredients = mealDetail.ingredients
        #expect(ingredients.count == 5) // 2 standard + 3 extended
        
        // Check that extended ingredients are included
        let ingredientNames = ingredients.map { $0.name }
        #expect(ingredientNames.contains("vanilla extract"))
        #expect(ingredientNames.contains("chocolate chips"))
        #expect(ingredientNames.contains("salt"))
    }
    
    @Test("MealDetail handles malformed keys gracefully")
    func malformedKeysHandling() throws {
        let jsonData = malformedMealJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        // Verify that malformed keys are stored but don't break processing
        #expect(mealDetail.rawIngredients["strIngredient"] == "malformed ingredient without number")
        #expect(mealDetail.rawMeasures["strMeasure"] == "malformed measure without number")
        
        // Verify that only valid indexed ingredients are processed
        let ingredients = mealDetail.ingredients
        #expect(ingredients.count == 2) // Only indices 1 and 3 have both ingredient and measure
        
        #expect(ingredients[0].name == "valid ingredient")
        #expect(ingredients[0].measure == "1 cup")
        #expect(ingredients[1].name == "another valid ingredient")
        #expect(ingredients[1].measure == "2 cups")
    }
    
    @Test("MealDetail requires both ingredient and measure for inclusion")
    func incompleteIngredientsFiltering() throws {
        let jsonData = incompleteMealJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        // Verify that ingredients without corresponding measures are excluded
        let ingredients = mealDetail.ingredients
        #expect(ingredients.count == 2) // Only indices 1 and 3 have both
        
        #expect(ingredients[0].name == "ingredient with measure")
        #expect(ingredients[0].measure == "1 cup")
        #expect(ingredients[1].name == "another ingredient with measure")
        #expect(ingredients[1].measure == "2 tbsp")
        
        // Verify that ingredient 2 is excluded (no measure)
        let ingredientNames = ingredients.map { $0.name }
        #expect(!ingredientNames.contains("ingredient without measure"))
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("MealDetail handles empty ingredients and measures")
    func emptyIngredientsHandling() throws {
        let emptyJSON = """
        {
            "idMeal": "99999",
            "strMeal": "Empty Recipe",
            "strInstructions": "A recipe with no ingredients...",
            "strMealThumb": "https://example.com/image.jpg"
        }
        """
        
        let jsonData = emptyJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        #expect(mealDetail.rawIngredients.isEmpty)
        #expect(mealDetail.rawMeasures.isEmpty)
        #expect(mealDetail.ingredients.isEmpty)
    }
    
    @Test("MealDetail handles whitespace-only ingredients")
    func whitespaceIngredientsFiltering() throws {
        let whitespaceJSON = """
        {
            "idMeal": "88888",
            "strMeal": "Whitespace Recipe",
            "strInstructions": "A recipe with whitespace...",
            "strMealThumb": "https://example.com/image.jpg",
            "strIngredient1": "  ",
            "strIngredient2": "valid ingredient",
            "strIngredient3": "\\t\\n",
            "strMeasure1": "  ",
            "strMeasure2": "1 cup",
            "strMeasure3": "\\t\\n"
        }
        """
        
        let jsonData = whitespaceJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
        
        // Only ingredient 2 should be included (has both valid ingredient and measure)
        let ingredients = mealDetail.ingredients
        #expect(ingredients.count == 1)
        #expect(ingredients[0].name == "valid ingredient")
        #expect(ingredients[0].measure == "1 cup")
    }
    
    // MARK: - Encoding Tests
    
    @Test("MealDetail encodes and decodes consistently")
    func roundTripEncoding() throws {
        let originalData = standardMealJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        // Decode
        let originalMeal = try decoder.decode(MealDetail.self, from: originalData)
        
        // Encode
        let encodedData = try encoder.encode(originalMeal)
        
        // Decode again
        let roundTripMeal = try decoder.decode(MealDetail.self, from: encodedData)
        
        // Verify consistency
        #expect(originalMeal.idMeal == roundTripMeal.idMeal)
        #expect(originalMeal.strMeal == roundTripMeal.strMeal)
        #expect(originalMeal.strInstructions == roundTripMeal.strInstructions)
        #expect(originalMeal.strMealThumb == roundTripMeal.strMealThumb)
        
        // Verify ingredients are the same
        #expect(originalMeal.ingredients.count == roundTripMeal.ingredients.count)
        
        for (original, roundTrip) in zip(originalMeal.ingredients, roundTripMeal.ingredients) {
            #expect(original.name == roundTrip.name)
            #expect(original.measure == roundTrip.measure)
        }
    }
    
    // MARK: - Ingredient Model Tests
    
    @Test("Ingredient model properties work correctly")
    func ingredientModel() {
        let ingredient = Ingredient(name: "flour", measure: "2 cups")
        
        #expect(ingredient.name == "flour")
        #expect(ingredient.measure == "2 cups")
        #expect(ingredient.id == "flour-2 cups")
        #expect(ingredient.displayText == "2 cups flour")
    }
    
    @Test("Ingredient model handles special characters")
    func ingredientWithSpecialCharacters() {
        let ingredient = Ingredient(name: "jalapeño peppers", measure: "1/2 cup")
        
        #expect(ingredient.name == "jalapeño peppers")
        #expect(ingredient.measure == "1/2 cup")
        #expect(ingredient.id == "jalapeño peppers-1/2 cup")
        #expect(ingredient.displayText == "1/2 cup jalapeño peppers")
    }
    
    // MARK: - Response Container Tests
    
    @Test("MealDetailResponse decodes correctly")
    func mealDetailResponseDecoding() throws {
        let responseJSON = """
        {
            "meals": [
                {
                    "idMeal": "52768",
                    "strMeal": "Apple Frangipane Tart",
                    "strInstructions": "Instructions...",
                    "strMealThumb": "https://example.com/image.jpg",
                    "strIngredient1": "flour",
                    "strMeasure1": "2 cups"
                }
            ]
        }
        """
        
        let jsonData = responseJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(MealDetailResponse.self, from: jsonData)
        
        #expect(response.meals?.count == 1)
        #expect(response.meals?.first?.idMeal == "52768")
        #expect(response.meals?.first?.strMeal == "Apple Frangipane Tart")
    }
    
    @Test("MealDetailResponse handles null meals")
    func mealDetailResponseNullMeals() throws {
        let responseJSON = """
        {
            "meals": null
        }
        """
        
        let jsonData = responseJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(MealDetailResponse.self, from: jsonData)
        
        #expect(response.meals == nil)
    }
}