//
//  NetworkServiceProtocol.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Protocol defining the network service interface for fetching meal data
protocol NetworkServiceProtocol: Sendable {
    
    /// Fetches the list of available meal categories
    /// - Returns: Array of MealCategory objects
    /// - Throws: NetworkError if the request fails
    func fetchCategories() async throws -> [MealCategory]
    
    /// Fetches meals by category from the API
    /// - Parameter category: The category name to filter by
    /// - Returns: Array of Meal objects for the specified category
    /// - Throws: NetworkError if the request fails
    func fetchMealsByCategory(_ category: String) async throws -> [Meal]
    
    /// Fetches detailed information for a specific meal by ID
    /// - Parameter id: The unique identifier of the meal
    /// - Returns: MealDetail object containing comprehensive meal information
    /// - Throws: NetworkError if the request fails or meal is not found
    func fetchMealDetail(id: String) async throws -> MealDetail
}