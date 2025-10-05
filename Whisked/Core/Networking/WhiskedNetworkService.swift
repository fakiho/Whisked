//
//  WhiskedNetworkService.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import Combine

/// Network service for handling API requests to TheMealDB
@MainActor
final class WhiskedNetworkService: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = WhiskedNetworkService()
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    
    // MARK: - Initialization
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - API Methods
    
    /// Fetches the list of desserts from the API
    /// - Returns: Array of desserts
    /// - Throws: NetworkError if the request fails
    func fetchDesserts() async throws -> [WhiskedDessert] {
        let url = URL(string: "\(baseURL)/filter.php?c=Dessert")!
        
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(WhiskedDessertsResponse.self, from: data)
        
        return response.meals.sorted { $0.name < $1.name }
    }
    
    /// Fetches detailed information for a specific dessert
    /// - Parameter id: The dessert ID
    /// - Returns: Detailed dessert information
    /// - Throws: NetworkError if the request fails
    func fetchDessertDetail(id: String) async throws -> WhiskedDessertDetail {
        let url = URL(string: "\(baseURL)/lookup.php?i=\(id)")!
        
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(WhiskedDessertDetailResponse.self, from: data)
        
        guard let dessert = response.meals.first else {
            throw WhiskedNetworkError.dessertNotFound
        }
        
        return dessert
    }
}

// MARK: - Response Models

/// Response model for the desserts list API
private struct WhiskedDessertsResponse: Codable, Sendable {
    let meals: [WhiskedDessert]
}

/// Response model for the dessert detail API
private struct WhiskedDessertDetailResponse: Codable, Sendable {
    let meals: [WhiskedDessertDetail]
}

// MARK: - Network Errors

/// Enumeration of possible network errors
enum WhiskedNetworkError: LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingError
    case dessertNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .dessertNotFound:
            return "Dessert not found"
        }
    }
}
