//
//  MockMealService.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation
import Combine

// MARK: - Mock Implementation

/// Mock implementation of MealServiceProtocol for testing and previews
@MainActor
final class MockMealService: MealServiceProtocol, ObservableObject {
    
    // MARK: - Properties
    
    /// Controls whether the mock should simulate network delays
    var shouldSimulateNetworkDelay: Bool = true
    
    /// Controls whether the mock should simulate errors
    var shouldSimulateError: Bool = false
    
    /// The error to simulate when shouldSimulateError is true
    var errorToSimulate: MealServiceError = .noInternetConnection
    
    /// Network delay duration in seconds
    var networkDelayDuration: TimeInterval = 1.0
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - MealServiceProtocol Implementation
    
    func fetchCategories() async throws -> [MealCategory] {
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelayDuration * 1_000_000_000))
        }
        
        if shouldSimulateError {
            throw errorToSimulate
        }
        
        return mockCategories
    }
    
    func fetchMealsByCategory(_ category: String) async throws -> [Meal] {
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelayDuration * 1_000_000_000))
        }
        
        if shouldSimulateError {
            throw errorToSimulate
        }
        
        return mockMeals
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail {
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelayDuration * 1_000_000_000))
        }
        
        if shouldSimulateError {
            throw errorToSimulate
        }
        
        guard let mockDetail = mockMealDetails.first(where: { $0.id == id }) else {
            throw MealServiceError.mealNotFound
        }
        
        return mockDetail
    }
    
    // MARK: - Mock Data
    
    private let mockCategories: [MealCategory] = [
        MealCategory(
            id: "1",
            name: "Dessert",
            description: "Sweet treats and desserts from around the world",
            thumbnailURL: "https://www.themealdb.com/images/category/dessert.png"
        ),
        MealCategory(
            id: "2",
            name: "Breakfast", 
            description: "Start your day right with these breakfast recipes",
            thumbnailURL: "https://www.themealdb.com/images/category/breakfast.png"
        )
    ]
    
    private let mockMeals: [Meal] = [
        Meal(
            id: "52893",
            name: "Apple & Blackberry Crumble",
            thumbnailURL: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
        ),
        Meal(
            id: "52768",
            name: "Apple Frangipan Tart",
            thumbnailURL: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"
        ),
        Meal(
            id: "52767",
            name: "Bakewell tart",
            thumbnailURL: "https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg"
        )
    ]
    
    private let mockMealDetails: [MealDetail] = [
        MealDetail(
            id: "52893",
            name: "Apple & Blackberry Crumble",
            instructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\n\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and, once the butter is melted, add the apples and cook until slightly softened and golden. Add the blackberries and cinnamon, and cook for 3 mins. Remove from the heat.\n\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with custard or ice cream.",
            thumbnailURL: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            ingredients: [
                Ingredient(name: "Plain Flour", measure: "120g"),
                Ingredient(name: "Caster Sugar", measure: "60g"),
                Ingredient(name: "Butter", measure: "60g"),
                Ingredient(name: "Braeburn Apples", measure: "300g"),
                Ingredient(name: "Butter", measure: "30g"),
                Ingredient(name: "Demerara Sugar", measure: "30g"),
                Ingredient(name: "Blackberrys", measure: "120g"),
                Ingredient(name: "Cinnamon", measure: "1 tsp"),
                Ingredient(name: "Ice Cream", measure: "to serve")
            ]
        )
    ]
}

// MARK: - Mock Service Factory

extension MockMealService {
    
    /// Creates a mock service configured for successful responses
    static func success() -> MockMealService {
        let service = MockMealService()
        service.shouldSimulateError = false
        service.shouldSimulateNetworkDelay = false
        return service
    }
    
    /// Creates a mock service configured for network errors
    static func networkError() -> MockMealService {
        let service = MockMealService()
        service.shouldSimulateError = true
        service.errorToSimulate = .noInternetConnection
        return service
    }
    
    /// Creates a mock service configured for not found errors
    static func notFoundError() -> MockMealService {
        let service = MockMealService()
        service.shouldSimulateError = true
        service.errorToSimulate = .mealNotFound
        return service
    }
    
    /// Creates a mock service configured to simulate slow network
    static func slowNetwork() -> MockMealService {
        let service = MockMealService()
        service.shouldSimulateNetworkDelay = true
        service.networkDelayDuration = 3.0
        return service
    }
}
