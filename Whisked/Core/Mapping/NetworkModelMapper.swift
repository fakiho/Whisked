//
//  NetworkModelMapper.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation
import NetworkKit

/// Mapper responsible for converting NetworkKit models to consumer domain models
enum NetworkModelMapper {
    
    // MARK: - MealCategory Mapping
    
    /// Maps NetworkKit.MealCategory to domain MealCategory
    /// - Parameter networkCategory: The NetworkKit MealCategory to map
    /// - Returns: Domain MealCategory
    static func mapToMealCategory(_ networkCategory: NetworkKit.MealCategory) -> MealCategory {
        return MealCategory(
            id: networkCategory.id,
            name: networkCategory.name,
            description: networkCategory.description,
            thumbnailURL: networkCategory.thumbnailURL
        )
    }
    
    /// Maps an array of NetworkKit.MealCategory to domain MealCategory array
    /// - Parameter networkCategories: Array of NetworkKit MealCategory to map
    /// - Returns: Array of domain MealCategory
    static func mapToMealCategories(_ networkCategories: [NetworkKit.MealCategory]) -> [MealCategory] {
        return networkCategories.map(mapToMealCategory)
    }
    
    // MARK: - Meal Mapping
    
    /// Maps NetworkKit.Meal to domain Meal
    /// - Parameter networkMeal: The NetworkKit Meal to map
    /// - Returns: Domain Meal
    static func mapToMeal(_ networkMeal: NetworkKit.Meal) -> Meal {
        return Meal(
            id: networkMeal.id,
            name: networkMeal.name,
            thumbnailURL: networkMeal.thumbnailURL
        )
    }
    
    /// Maps an array of NetworkKit.Meal to domain Meal array
    /// - Parameter networkMeals: Array of NetworkKit Meal to map
    /// - Returns: Array of domain Meal
    static func mapToMeals(_ networkMeals: [NetworkKit.Meal]) -> [Meal] {
        return networkMeals.map(mapToMeal)
    }
    
    // MARK: - MealDetail Mapping
    
    /// Maps NetworkKit.MealDetail to domain MealDetail
    /// - Parameter networkMealDetail: The NetworkKit MealDetail to map
    /// - Returns: Domain MealDetail
    static func mapToMealDetail(_ networkMealDetail: NetworkKit.MealDetail) -> MealDetail {
        let domainIngredients = networkMealDetail.ingredients.map { networkIngredient in
            Ingredient(
                name: networkIngredient.name,
                measure: networkIngredient.measure
            )
        }
        
        return MealDetail(
            id: networkMealDetail.id,
            name: networkMealDetail.name,
            instructions: networkMealDetail.instructions,
            thumbnailURL: networkMealDetail.thumbnailURL,
            ingredients: domainIngredients
        )
    }
    
    // MARK: - Error Mapping
    
    /// Maps NetworkKit.NetworkError to domain MealServiceError
    /// - Parameter networkError: The NetworkKit NetworkError to map
    /// - Returns: Domain MealServiceError
    static func mapToMealServiceError(_ networkError: NetworkKit.NetworkError) -> MealServiceError {
        switch networkError {
        case .noInternetConnection:
            return .noInternetConnection
        case .timeout:
            return .timeout
        case .httpError(let statusCode, _):
            return .serverError(statusCode: statusCode)
        case .decodingError, .encodingError:
            return .invalidResponse
        case .mealNotFound:
            return .mealNotFound
        case .emptyResponse:
            return .noMealsFound
        case .invalidURL(let url):
            return .networkError("Invalid URL: \(url)")
        case .noData:
            return .invalidResponse
        case .networkError(let error):
            return .networkError(error.localizedDescription)
        case .unknown:
            return .unknown
        }
    }
    
    /// Maps any Error to domain MealServiceError with appropriate fallbacks
    /// - Parameter error: The error to map
    /// - Returns: Domain MealServiceError
    static func mapErrorToMealServiceError(_ error: Error) -> MealServiceError {
        // First try to cast as NetworkKit.NetworkError
        if let networkError = error as? NetworkKit.NetworkError {
            return mapToMealServiceError(networkError)
        }
        
        // Handle URLError specifically
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            case .cancelled:
                return .unknown // Don't show error for cancelled requests
            case .cannotFindHost, .cannotConnectToHost:
                return .networkError("Cannot reach server")
            default:
                return .networkError("Network error: \(urlError.localizedDescription)")
            }
        }
        
        // Fallback for any other error
        return .networkError(error.localizedDescription)
    }
}