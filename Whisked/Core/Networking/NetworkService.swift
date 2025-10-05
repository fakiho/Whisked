//
//  NetworkService.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import Network
import Combine

/// Concrete implementation of NetworkServiceProtocol for live API calls
final class NetworkService: NetworkServiceProtocol, ObservableObject {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    /// Initializes the NetworkService with a URLSession
    /// - Parameter session: The URLSession to use for network requests. 
    ///   If not provided, uses URLSessionFactory.createOptimizedSession()
    init(session: URLSession? = nil) {
        self.session = session ?? URLSessionFactory.createOptimizedSession()
        self.jsonDecoder = JSONDecoder()
    }    // MARK: - NetworkServiceProtocol Conformance
    
    func fetchDesserts() async throws -> [Meal] {
        let urlString = "\(baseURL)/filter.php?c=Dessert"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(urlString)
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            // Validate HTTP response
            try validateHTTPResponse(response, data: data)
            
            // Check for empty data
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            // Decode the response
            let mealsResponse = try jsonDecoder.decode(MealsResponse.self, from: data)
            
            // Validate we have meals in the response
            guard !mealsResponse.meals.isEmpty else {
                throw NetworkError.emptyResponse
            }
            
            // Return sorted meals for consistent UI experience
            return mealsResponse.meals.sorted { $0.strMeal < $1.strMeal }
            
        } catch let error as NetworkError {
            throw error
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let urlError as URLError {
            throw mapURLError(urlError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail {
        let urlString = "\(baseURL)/lookup.php?i=\(id)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(urlString)
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            // Validate HTTP response
            try validateHTTPResponse(response, data: data)
            
            // Check for empty data
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            // Decode the response
            let mealDetailResponse = try jsonDecoder.decode(MealDetailResponse.self, from: data)
            
            // Validate we have a meal in the response
            guard let mealDetail = mealDetailResponse.meals.first else {
                throw NetworkError.mealNotFound
            }
            
            return mealDetail
            
        } catch let error as NetworkError {
            throw error
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let urlError as URLError {
            throw mapURLError(urlError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Validates HTTP response and status codes
    private func validateHTTPResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        let statusCode = httpResponse.statusCode
        
        // Check for successful status codes (200-299)
        guard 200...299 ~= statusCode else {
            throw NetworkError.httpError(statusCode: statusCode, data: data)
        }
    }
    
    /// Maps URLError to appropriate NetworkError
    private func mapURLError(_ urlError: URLError) -> NetworkError {
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
