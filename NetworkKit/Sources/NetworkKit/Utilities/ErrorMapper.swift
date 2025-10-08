//
//  ErrorMapper.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation

struct ErrorMapper {
    // MARK: - Private Helper Methods

    /// Validates HTTP response and status codes
    /// - Parameters:
    ///   - response: The URLResponse received from the network request
    ///   - data: The data received from the network request
    /// - Throws: NetworkError if the response is invalid or contains an error status code
    static func validateHTTPResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        let statusCode = httpResponse.statusCode

        // Check for successful status codes (200-299)
        guard 200...299 ~= statusCode else {
            throw NetworkError.httpError(statusCode: statusCode, data: data)
        }
    }

    /// Maps URLError to appropriate NetworkError for consistent error handling
    /// - Parameter urlError: The URLError to be mapped
    /// - Returns: A corresponding NetworkError case
    static func mapURLError(_ urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternetConnection
        case .timedOut:
            return .timeout
        case .cannotFindHost, .cannotConnectToHost:
            return .networkError(urlError)
        default:
            return .networkError(urlError)
        }
    }
}
