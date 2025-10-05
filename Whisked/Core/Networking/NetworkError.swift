//
//  NetworkError.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Comprehensive error types for network operations
enum NetworkError: LocalizedError, Equatable, Sendable {
    
    // MARK: - Error Cases
    
    /// Invalid URL construction
    case invalidURL(String)
    
    /// No internet connection
    case noInternetConnection
    
    /// Request timeout
    case timeout
    
    /// HTTP status code errors
    case httpError(statusCode: Int, data: Data?)
    
    /// JSON decoding failed
    case decodingError(DecodingError)
    
    /// JSON encoding failed
    case encodingError(EncodingError)
    
    /// No data received from server
    case noData
    
    /// Meal not found in response
    case mealNotFound
    
    /// Server returned empty response
    case emptyResponse
    
    /// Generic network error
    case networkError(Error)
    
    /// Unknown error occurred
    case unknown
    
    // MARK: - LocalizedError Conformance
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .noInternetConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timed out"
        case .httpError(let statusCode, _):
            return "HTTP error with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode server response"
        case .encodingError:
            return "Failed to encode request data"
        case .noData:
            return "No data received from server"
        case .mealNotFound:
            return "Meal not found"
        case .emptyResponse:
            return "Server returned empty response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is malformed or invalid"
        case .noInternetConnection:
            return "Check your internet connection and try again"
        case .timeout:
            return "The server took too long to respond"
        case .httpError(let statusCode, _):
            return httpErrorReason(for: statusCode)
        case .decodingError:
            return "The server response format is unexpected"
        case .encodingError:
            return "Failed to prepare request data"
        case .noData:
            return "The server did not return any data"
        case .mealNotFound:
            return "The requested meal could not be found"
        case .emptyResponse:
            return "The server returned an empty response"
        case .networkError:
            return "A network-level error occurred"
        case .unknown:
            return "An unexpected error occurred"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Contact the app developer to report this issue"
        case .noInternetConnection:
            return "Check your Wi-Fi or cellular connection and try again"
        case .timeout:
            return "Try again in a few moments"
        case .httpError(let statusCode, _):
            return httpRecoverySuggestion(for: statusCode)
        case .decodingError, .encodingError:
            return "Try updating the app or contact support if the issue persists"
        case .noData, .emptyResponse:
            return "Try refreshing or check back later"
        case .mealNotFound:
            return "Try searching for a different meal"
        case .networkError, .unknown:
            return "Try again later or contact support if the issue persists"
        }
    }
    
    // MARK: - Equatable Conformance
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL(let lhsURL), .invalidURL(let rhsURL)):
            return lhsURL == rhsURL
        case (.noInternetConnection, .noInternetConnection),
             (.timeout, .timeout),
             (.noData, .noData),
             (.mealNotFound, .mealNotFound),
             (.emptyResponse, .emptyResponse),
             (.unknown, .unknown):
            return true
        case (.httpError(let lhsCode, _), .httpError(let rhsCode, _)):
            return lhsCode == rhsCode
        case (.decodingError, .decodingError),
             (.encodingError, .encodingError),
             (.networkError, .networkError):
            return true // Simplified comparison for error types
        default:
            return false
        }
    }
    
    // MARK: - Helper Methods
    
    /// Provides specific error reasons for HTTP status codes
    private func httpErrorReason(for statusCode: Int) -> String {
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
    
    /// Provides recovery suggestions for HTTP status codes
    private func httpRecoverySuggestion(for statusCode: Int) -> String {
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