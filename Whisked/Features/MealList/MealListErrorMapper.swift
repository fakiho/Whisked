//
//  MealListErrorMapper.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/6/25.
//

import Foundation
import NetworkKit

/// Utility class for mapping network and service errors to user-friendly localized messages
/// Keeps MealListViewModel focused on its core responsibilities
struct MealListErrorMapper {
    
    /// Maps various types of errors to localized, user-friendly messages
    /// - Parameter error: The error to map
    /// - Returns: A localized error message string
    static func mapErrorToUserFriendlyMessage(_ error: Error) -> String {
        // Handle URLError specifically
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return LocalizedStrings.errorMealsNoInternet
            case .timedOut:
                return LocalizedStrings.errorMealsTimeout
            case .cancelled:
                return LocalizedStrings.errorMealsCancelled
            case .cannotFindHost, .cannotConnectToHost:
                return LocalizedStrings.errorMealsCannotReachServer
            default:
                return LocalizedStrings.errorMealsNetworkError
            }
        }
        
        // Handle NetworkKit errors
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noInternetConnection:
                return LocalizedStrings.errorMealsNoInternet
            case .timeout:
                return LocalizedStrings.errorMealsTimeout
            case .httpError(let statusCode, _):
                return LocalizedStrings.errorMealsServerError(statusCode: statusCode)
            case .decodingError:
                return LocalizedStrings.errorMealsDecodingError
            case .emptyResponse:
                return LocalizedStrings.errorMealsNoMealsFound
            default:
                return LocalizedStrings.errorMealsUnexpectedError
            }
        }
        
        // Fallback for any other error types
        return LocalizedStrings.errorMealsUnexpectedError
    }
}