//
//  DessertDetailViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// ViewModel for managing the dessert detail screen state and data
@MainActor
@Observable
final class DessertDetailViewModel {
    
    // MARK: - Published Properties
    
    /// Current view state
    private(set) var state: ViewState = .loading
    
    /// The meal ID being displayed
    let mealID: String
    
    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a meal ID and network service
    /// - Parameters:
    ///   - mealID: The unique identifier of the meal to fetch details for
    ///   - networkService: The network service for fetching meal detail data
    init(mealID: String, networkService: NetworkServiceProtocol) {
        self.mealID = mealID
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    /// Fetches meal details from the API and updates the view state
    func fetchMealDetails() async {
        state = .loading
        
        do {
            let mealDetail = try await networkService.fetchMealDetail(id: mealID)
            state = .success(mealDetail)
        } catch {
            // Don't show error for cancelled requests
            if let urlError = error as? URLError, urlError.code == .cancelled {
                return
            }
            let errorMessage = mapErrorToUserFriendlyMessage(error)
            state = .error(errorMessage)
        }
    }
    
    /// Refreshes the meal details
    func refresh() async {
        // Don't change state to loading during refresh to avoid UI flicker
        do {
            let mealDetail = try await networkService.fetchMealDetail(id: mealID)
            state = .success(mealDetail)
        } catch {
            // Don't show error for cancelled requests
            if let urlError = error as? URLError, urlError.code == .cancelled {
                return
            }
            let errorMessage = mapErrorToUserFriendlyMessage(error)
            state = .error(errorMessage)
        }
    }
    
    /// Retries fetching meal details after an error
    func retry() async {
        await fetchMealDetails()
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
            case .mealNotFound:
                return "This dessert recipe could not be found. It may have been removed."
            case .emptyResponse:
                return "No recipe details found. Please try again later."
            default:
                return "Something went wrong. Please try again."
            }
        } else {
            return "An unexpected error occurred. Please try again."
        }
    }
}

// MARK: - ViewState

extension DessertDetailViewModel {
    
    /// Enumeration representing the possible states of the dessert detail view
    enum ViewState: Equatable, Sendable {
        case loading
        case success(MealDetail)
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
        
        /// Computed property to get the meal detail if in success state
        var mealDetail: MealDetail? {
            if case .success(let mealDetail) = self {
                return mealDetail
            }
            return nil
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