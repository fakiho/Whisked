//
//  MealServiceProtocol.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Service protocol for meal operations using domain models
protocol MealServiceProtocol: Sendable {
    
    /// Fetches the list of available meal categories
    /// - Returns: Array of domain MealCategory objects
    /// - Throws: MealServiceError if the request fails
    func fetchCategories() async throws -> [MealCategory]
    
    /// Fetches meals by category from the API
    /// - Parameter category: The category name to filter by
    /// - Returns: Array of domain Meal objects for the specified category
    /// - Throws: MealServiceError if the request fails
    func fetchMealsByCategory(_ category: String) async throws -> [Meal]
    
    /// Fetches detailed information for a specific meal by ID
    /// - Parameter id: The unique identifier of the meal
    /// - Returns: Domain MealDetail object containing comprehensive meal information
    /// - Throws: MealServiceError if the request fails or meal is not found
    func fetchMealDetail(id: String) async throws -> MealDetail
}
