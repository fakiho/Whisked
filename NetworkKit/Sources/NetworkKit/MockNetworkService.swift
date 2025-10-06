//
//  MockNetworkService.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation
import Combine

/// Mock implementation of NetworkServiceProtocol for testing and SwiftUI Previews
@MainActor
public final class MockNetworkService: NetworkServiceProtocol, ObservableObject {
    
    // MARK: - Properties
    
    /// Controls whether the mock should simulate network delays
    public var shouldSimulateNetworkDelay: Bool = true
    
    /// Controls whether the mock should simulate errors
    public var shouldSimulateError: Bool = false
    
    /// The error to simulate when shouldSimulateError is true
    public var errorToSimulate: NetworkError = .networkError(URLError(.notConnectedToInternet))
    
    /// Network delay duration in seconds
    public var networkDelayDuration: TimeInterval = 1.0
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - NetworkServiceProtocol Conformance
    
    public func fetchCategories() async throws -> [MealCategory] {
        // Simulate network delay if enabled
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelayDuration * 1_000_000_000))
        }
        
        // Simulate error if enabled
        if shouldSimulateError {
            throw errorToSimulate
        }
        
        return MealCategory.supportedCategories
    }
    
    public func fetchMealsByCategory(_ category: String) async throws -> [Meal] {
        // Simulate network delay if enabled
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelayDuration * 1_000_000_000))
        }
        
        // Simulate error if enabled
        if shouldSimulateError {
            throw errorToSimulate
        }
        
        // Filter mock meal based on category
        // For mock purposes, return all desserts for any category request
        return mockDesserts
    }
    
    public func fetchMealDetail(id: String) async throws -> MealDetail {
        // Simulate network delay if enabled
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelayDuration * 1_000_000_000))
        }
        
        // Simulate error if enabled
        if shouldSimulateError {
            throw errorToSimulate
        }
        
        // Return corresponding mock detail or throw not found error
        guard let mockDetail = mockMealDetails.first(where: { $0.idMeal == id }) else {
            throw NetworkError.mealNotFound
        }
        
        return mockDetail
    }
    
    // MARK: - Mock Data
    
    /// Hardcoded mock desserts for testing and previews
    private let mockDesserts: [Meal] = [
        Meal(
            idMeal: "52893",
            strMeal: "Apple & Blackberry Crumble",
            strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"
        ),
        Meal(
            idMeal: "52768",
            strMeal: "Apple Frangipan Tart",
            strMealThumb: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg"
        ),
        Meal(
            idMeal: "52767",
            strMeal: "Bakewell tart",
            strMealThumb: "https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg"
        ),
        Meal(
            idMeal: "52855",
            strMeal: "Banana Pancakes",
            strMealThumb: "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg"
        ),
        Meal(
            idMeal: "52928",
            strMeal: "BeaverTails",
            strMealThumb: "https://www.themealdb.com/images/media/meals/ryppsv1511815505.jpg"
        ),
        Meal(
            idMeal: "52891",
            strMeal: "Blackberry Fool",
            strMealThumb: "https://www.themealdb.com/images/media/meals/rpvptu1511641092.jpg"
        ),
        Meal(
            idMeal: "52764",
            strMeal: "Bread and Butter Pudding",
            strMealThumb: "https://www.themealdb.com/images/media/meals/xqwwpy1483908697.jpg"
        ),
        Meal(
            idMeal: "52792",
            strMeal: "Budino Di Ricotta",
            strMealThumb: "https://www.themealdb.com/images/media/meals/1549542877.jpg"
        )
    ]
    
    /// Hardcoded mock meal details for testing and previews
    private let mockMealDetails: [MealDetail] = [
        MealDetail(
            idMeal: "52893",
            strMeal: "Apple & Blackberry Crumble",
            strInstructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\n\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and, once the butter is melted, add the apples and cook until slightly softened and golden. Add the blackberries and cinnamon, and cook for 3 mins. Remove from the heat.\n\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with custard or ice cream.",
            strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
            strIngredient1: "Plain Flour",
            strIngredient2: "Caster Sugar",
            strIngredient3: "Butter",
            strIngredient4: "Braeburn Apples",
            strIngredient5: "Butter",
            strIngredient6: "Demerara Sugar",
            strIngredient7: "Blackberrys",
            strIngredient8: "Cinnamon",
            strIngredient9: "Ice Cream",
            strMeasure1: "120g",
            strMeasure2: "60g",
            strMeasure3: "60g",
            strMeasure4: "300g",
            strMeasure5: "30g",
            strMeasure6: "30g",
            strMeasure7: "120g",
            strMeasure8: "1 tsp",
            strMeasure9: "to serve"
        ),
        MealDetail(
            idMeal: "52768",
            strMeal: "Apple Frangipan Tart",
            strInstructions: "Preheat the oven to 200C/180C Fan/Gas 6.\nPut the biscuits in a large re-sealable freezer bag and bash with a rolling pin into fine crumbs. Melt the butter in a small pan, then add the biscuit crumbs and stir until coated with butter. Tip into the tart tin and, using the back of a spoon, press over the base and sides of the tin to give an even layer. Chill in the fridge while you make the filling.\n\nCream together the butter and sugar until light and fluffy. You can do this in a food processor if you have one. Process for 2-3 minutes. Mix in the eggs, then add the ground almonds and almond extract and process until well combined.\n\nPeel the apples, and cut thin slices of apple. Do this at the last minute to prevent the apple going brown. Arrange the slices over the biscuit base. Spread the frangipane filling evenly on top. Level the surface and sprinkle with the flaked almonds.\n\nBake for 20-25 minutes until golden-brown and set.\n\nRemove from the oven and leave to cool for 15 minutes. Remove the sides of the tin. An easy way to do this is to stand the tin on a can of beans and push down gently on the sides of the tin. Slide the tart off the base of the tin onto a serving plate. Serve warm with cream, crème fraiche or custard.\n\nIf you are making this ahead, store in the fridge and reheat in a low oven (120C/100C Fan/Gas 1/2) for 15-20 minutes to serve warm.",
            strMealThumb: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
            strIngredient1: "digestive biscuits",
            strIngredient2: "butter",
            strIngredient3: "Bramley apples",
            strIngredient4: "butter, softened",
            strIngredient5: "caster sugar",
            strIngredient6: "free-range eggs, beaten",
            strIngredient7: "ground almonds",
            strIngredient8: "almond extract",
            strIngredient9: "flaked almonds",
            strMeasure1: "175g/6oz",
            strMeasure2: "75g/3oz",
            strMeasure3: "200g/7oz",
            strMeasure4: "75g/3oz",
            strMeasure5: "75g/3oz",
            strMeasure6: "2",
            strMeasure7: "75g/3oz",
            strMeasure8: "1 tsp",
            strMeasure9: "25g/1oz"
        )
    ]
}

// MARK: - Mock Service Factory

public extension MockNetworkService {
    
    /// Creates a mock service configured for successful responses
    static func success() -> MockNetworkService {
        let service = MockNetworkService()
        service.shouldSimulateError = false
        service.shouldSimulateNetworkDelay = false
        return service
    }
    
    /// Creates a mock service configured for network errors
    static func networkError() -> MockNetworkService {
        let service = MockNetworkService()
        service.shouldSimulateError = true
        service.errorToSimulate = .noInternetConnection
        return service
    }
    
    /// Creates a mock service configured for not found errors
    static func notFoundError() -> MockNetworkService {
        let service = MockNetworkService()
        service.shouldSimulateError = true
        service.errorToSimulate = .mealNotFound
        return service
    }
    
    /// Creates a mock service configured to simulate slow network
    static func slowNetwork() -> MockNetworkService {
        let service = MockNetworkService()
        service.shouldSimulateNetworkDelay = true
        service.networkDelayDuration = 3.0
        return service
    }
}