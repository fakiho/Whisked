//
//  NetworkServiceProtocol.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Protocol defining the contract for network services in the Whisked app
protocol NetworkServiceProtocol {
    
    /// Fetches the list of desserts from the API
    /// - Returns: Array of Meal objects representing desserts
    /// - Throws: NetworkError if the request fails
    func fetchDesserts() async throws -> [Meal]
    
    /// Fetches detailed information for a specific meal by ID
    /// - Parameter id: The unique identifier of the meal
    /// - Returns: MealDetail object containing comprehensive meal information
    /// - Throws: NetworkError if the request fails or meal is not found
    func fetchMealDetail(id: String) async throws -> MealDetail
}