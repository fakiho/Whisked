//
//  MealServiceError.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Domain error type for meal service operations
public enum MealServiceError: LocalizedError, Equatable, Sendable {
    
    // MARK: - Error Cases
    
    /// No internet connection
    case noInternetConnection
    
    /// Request timeout
    case timeout
    
    /// Server error with status code
    case serverError(statusCode: Int)
    
    /// Failed to process server response
    case invalidResponse
    
    /// Meal not found
    case mealNotFound
    
    /// No meals found for category
    case noMealsFound
    
    /// Generic network error
    case networkError(String)
    
    /// Unknown error occurred
    case unknown
    
    // MARK: - LocalizedError Conformance
    
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timed out"
        case .serverError(let statusCode):
            return "Server error (\(statusCode))"
        case .invalidResponse:
            return "Failed to process server response"
        case .mealNotFound:
            return "Meal not found"
        case .noMealsFound:
            return "No meals found"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .noInternetConnection:
            return "Check your internet connection and try again"
        case .timeout:
            return "The server took too long to respond"
        case .serverError(let statusCode):
            return serverErrorReason(for: statusCode)
        case .invalidResponse:
            return "The server response format is unexpected"
        case .mealNotFound:
            return "The requested meal could not be found"
        case .noMealsFound:
            return "No meals are available for this category"
        case .networkError:
            return "A network-level error occurred"
        case .unknown:
            return "An unexpected error occurred"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .noInternetConnection:
            return "Check your Wi-Fi or cellular connection and try again"
        case .timeout:
            return "Try again in a few moments"
        case .serverError(let statusCode):
            return serverRecoverySuggestion(for: statusCode)
        case .invalidResponse:
            return "Try updating the app or contact support if the issue persists"
        case .mealNotFound:
            return "Try searching for a different meal"
        case .noMealsFound:
            return "Try refreshing or check back later"
        case .networkError, .unknown:
            return "Try again later or contact support if the issue persists"
        }
    }
    
    // MARK: - Helper Methods
    
    private func serverErrorReason(for statusCode: Int) -> String {
        switch statusCode {
        case 400:
            return "Bad request - the server could not understand the request"
        case 401:
            return "Unauthorized - authentication required"
        case 403:
            return "Forbidden - access denied"
        case 404:
            return "Not found - the requested resource does not exist"
        case 429:
            return "Too many requests - rate limit exceeded"
        case 500...599:
            return "Server error - the server encountered an internal error"
        default:
            return "HTTP error occurred"
        }
    }
    
    private func serverRecoverySuggestion(for statusCode: Int) -> String {
        switch statusCode {
        case 400:
            return "Try refreshing the app or updating to the latest version"
        case 401, 403:
            return "Please check your account credentials"
        case 404:
            return "The content you're looking for may have been moved or deleted"
        case 429:
            return "Please wait a moment before trying again"
        case 500...599:
            return "The server is experiencing issues. Please try again later"
        default:
            return "Try again later or contact support if the issue persists"
        }
    }
}