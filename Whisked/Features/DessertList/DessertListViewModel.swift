//
//  DessertListViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// ViewModel for managing the meal list screen state and data
@MainActor
@Observable
final class DessertListViewModel {
    
    // MARK: - Published Properties
    
    /// Current view state
    private(set) var state: ViewState = .loading
    
    /// Array of meals fetched from the API
    private(set) var meals: [Meal] = []
    
    /// The category being filtered, if any
    private(set) var category: MealCategory
    
    // MARK: - Dependencies
    
    private let mealService: MealServiceProtocol
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a meal service and category
    /// - Parameters:
    ///   - mealService: The meal service for fetching meal data
    ///   - category: Category to filter meals by
    init(mealService: MealServiceProtocol, category: MealCategory) {
        self.mealService = mealService
        self.category = category
    }
    
    // MARK: - Public Methods
    
    /// Fetches meals from the API based on category and updates the view state
    func fetchMeals() async {
        state = .loading
        
        do {
            meals = try await mealService.fetchMealsByCategory(category.name)
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
            meals = try await mealService.fetchMealsByCategory(category.name)
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
    
    /// Retries fetching meals after an error
    func retry() async {
        await fetchMeals()
    }
    
    // MARK: - Private Methods
    
    /// Maps service errors to user-friendly messages
    private func mapErrorToUserFriendlyMessage(_ error: Error) -> String {
        // Handle URLError specifically (for cancelled requests)
        if let urlError = error as? URLError {
            switch urlError.code {
            case .cancelled:
                return "Request was cancelled. Please try again."
            default:
                return "Network error occurred. Please try again."
            }
        }
        
        // Handle domain service errors
        if let serviceError = error as? MealServiceError {
            switch serviceError {
            case .noInternetConnection:
                return "No internet connection. Please check your network and try again."
            case .timeout:
                return "Request timed out. Please try again."
            case .serverError(let statusCode):
                return "Server error (\(statusCode)). Please try again later."
            case .invalidResponse:
                return "Unable to process server response. Please try again."
            case .noMealsFound:
                return "No meals found. Please try again later."
            case .mealNotFound:
                return "Meal not found. Please try again."
            case .networkError(let message):
                return "Network error: \(message)"
            case .unknown:
                return "Something went wrong. Please try again."
            }
        }
        
        return "An unexpected error occurred. Please try again."
    }
}

// MARK: - ViewState

extension DessertListViewModel {
    
    /// Enumeration representing the possible states of the category list view
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