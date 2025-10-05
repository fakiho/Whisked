//
//  DessertListViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// ViewModel for managing the dessert list screen state and data
@MainActor
@Observable
final class DessertListViewModel {
    
    // MARK: - Published Properties
    
    /// Current view state
    private(set) var state: ViewState = .loading
    
    /// Array of desserts fetched from the API
    private(set) var desserts: [Meal] = []
    
    /// The category being filtered, if any
    private(set) var category: MealCategory
    
    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a network service and optional category
    /// - Parameters:
    ///   - networkService: The network service for fetching meal data
    ///   - category: Optional category to filter meals by
    init(networkService: NetworkServiceProtocol, category: MealCategory) {
        self.networkService = networkService
        self.category = category
    }
    
    // MARK: - Public Methods
    
    /// Fetches meals from the API based on category and updates the view state
    func fetchDesserts() async {
        state = .loading
        
        do {
            desserts = try await networkService.fetchMealsByCategory(category.id)
            state = .success
        } catch {
            // Don't show error for cancelled requests (common during pull-to-refresh)
            if let urlError = error as? URLError, urlError.code == .cancelled {
                return
            }
            let errorMessage = mapErrorToUserFriendlyMessage(error)
            state = .error(errorMessage)
        }
    }

    /// Refreshes the meal list
    func refresh() async {
        // Don't change state to loading during refresh to avoid UI flicker
        do {
            desserts = try await networkService.fetchMealsByCategory(category.id)
            state = .success
        } catch {
            // Don't show error for cancelled requests (common during pull-to-refresh)
            if let urlError = error as? URLError, urlError.code == .cancelled {
                return
            }
            let errorMessage = mapErrorToUserFriendlyMessage(error)
            state = .error(errorMessage)
        }
    }
    
    /// Retries fetching desserts after an error
    func retry() async {
        await fetchDesserts()
    }
    
    // MARK: - Private Methods
    
    /// Maps network errors to user-friendly messages
    private func mapErrorToUserFriendlyMessage(_ error: Error) -> String {
        // Handle URLError specifically
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. Please check your network and try again."
            case .timedOut:
                return "Request timed out. Please try again."
            case .cancelled:
                return "Request was cancelled. Please try again."
            case .cannotFindHost, .cannotConnectToHost:
                return "Cannot reach the server. Please try again later."
            default:
                return "Network error occurred. Please try again."
            }
        }
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noInternetConnection:
                return "No internet connection. Please check your network and try again."
            case .timeout:
                return "Request timed out. Please try again."
            case .httpError(let statusCode, _):
                return "Server error (\(statusCode)). Please try again later."
            case .decodingError:
                return "Unable to process server response. Please try again."
            case .emptyResponse:
                return "No desserts found. Please try again later."
            default:
                return "Something went wrong. Please try again."
            }
        } else {
            return "An unexpected error occurred. Please try again."
        }
    }
}

// MARK: - ViewState

extension DessertListViewModel {
    
    /// Enumeration representing the possible states of the dessert list view
    enum ViewState: Equatable, Sendable {
        case loading
        case success
        case error(String)
        
        /// Computed property to check if the view is in loading state
        var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
        
        /// Computed property to check if the view is in success state
        var isSuccess: Bool {
            if case .success = self {
                return true
            }
            return false
        }
        
        /// Computed property to get error message if in error state
        var errorMessage: String? {
            if case .error(let message) = self {
                return message
            }
            return nil
        }
    }
}
