//
//  MealDetailViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

// TODO: Add PersistenceKit import and full offline-first implementation
// For now, this is a placeholder for the PersistenceService dependency

/// Temporary placeholder protocol for PersistenceService
import Foundation
import SwiftUI

/// ViewModel for managing the meal detail screen state and data with offline-first capability
@MainActor
@Observable
final class MealDetailViewModel {
    
    // MARK: - Published Properties
    
    /// Current view state
    private(set) var state: ViewState = .loading
    
    /// The meal ID being displayed
    let mealID: String
    
    /// Whether the current meal is favorited
    private(set) var isFavorite: Bool = false
    
    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol?
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a meal ID, network service, and optional persistence service
    /// - Parameters:
    ///   - mealID: The unique identifier of the meal to fetch details for
    ///   - networkService: The network service for fetching meal detail data
    ///   - persistenceService: The persistence service for offline storage (optional for now)
    init(
        mealID: String, 
        networkService: NetworkServiceProtocol,
        persistenceService: PersistenceServiceProtocol? = nil
    ) {
        self.mealID = mealID
        self.networkService = networkService
        self.persistenceService = persistenceService
    }
    
    // MARK: - Public Methods
    
    /// Fetches meal details with offline-first strategy:
    /// 1. Check local storage first (if persistence service is available)
    /// 2. If found offline, use that data immediately
    /// 3. If not found offline or no persistence service, fetch from network
    func fetchMealDetails() async {
        state = .loading
        
        do {
            // Step 1: Check if meal is stored offline (favorited) - if persistence service is available
            if let persistenceService = persistenceService,
               let offlineMealData = try await persistenceService.fetchFavoriteMeal(by: mealID) {
                // Found offline! Convert to MealDetail and display immediately
                let mealDetail = MealDetail.fromOfflineData(
                    idMeal: offlineMealData.idMeal,
                    strMeal: offlineMealData.strMeal,
                    strMealThumb: offlineMealData.strMealThumb,
                    strInstructions: offlineMealData.strInstructions,
                    ingredients: offlineMealData.ingredients
                )
                
                isFavorite = true
                state = .success(mealDetail)
                return
            }
            
            // Step 2: Not found offline or no persistence service, fetch from network
            let mealDetail = try await networkService.fetchMealDetail(id: mealID)
            
            // Update favorite status if persistence service is available
            if let persistenceService = persistenceService {
                let favoriteIDs = try await persistenceService.fetchFavoriteIDs()
                isFavorite = favoriteIDs.contains(mealID)
            }
            
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
    
    /// Toggles the favorite status of the current meal
    /// - If favoriting: saves the complete meal data for offline access
    /// - If unfavoriting: removes the meal data from offline storage
    func toggleFavorite() async {
        guard let persistenceService = persistenceService,
              case .success(let mealDetail) = state else { return }
        
        do {
            if isFavorite {
                // Remove from favorites (delete offline data)
                try await persistenceService.deleteFavoriteMeal(by: mealID)
                isFavorite = false
            } else {
                // Add to favorites (save complete meal data for offline access)
                let offlineData = mealDetail.extractForOfflineStorage()
                try await persistenceService.saveFavoriteMeal(
                    idMeal: offlineData.idMeal,
                    strMeal: offlineData.strMeal,
                    strMealThumb: offlineData.strMealThumb,
                    strInstructions: offlineData.strInstructions,
                    ingredients: offlineData.ingredients
                )
                isFavorite = true
            }
        } catch {
            // Handle favorite toggle error silently or show a brief message
            // For now, we'll silently fail to avoid disrupting the user experience
            print("Failed to toggle favorite: \(error)")
        }
    }
    
    /// Refreshes the meal details
    func refresh() async {
        // Don't change state to loading during refresh to avoid UI flicker
        do {
            // Check offline first, then network if needed
            if let persistenceService = persistenceService,
               let offlineMealData = try await persistenceService.fetchFavoriteMeal(by: mealID) {
                let mealDetail = MealDetail.fromOfflineData(
                    idMeal: offlineMealData.idMeal,
                    strMeal: offlineMealData.strMeal,
                    strMealThumb: offlineMealData.strMealThumb,
                    strInstructions: offlineMealData.strInstructions,
                    ingredients: offlineMealData.ingredients
                )
                isFavorite = true
                state = .success(mealDetail)
                return
            }
            
            // Fetch from network
            let mealDetail = try await networkService.fetchMealDetail(id: mealID)
            
            // Update favorite status if persistence service is available
            if let persistenceService = persistenceService {
                let favoriteIDs = try await persistenceService.fetchFavoriteIDs()
                isFavorite = favoriteIDs.contains(mealID)
            }
            
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
                return "This meal recipe could not be found. It may have been removed."
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

extension MealDetailViewModel {
    
    /// Enumeration representing the possible states of the meal detail view
    enum ViewState: Equatable, Sendable {
        case loading
        case success(MealDetail)
        case error(String)
        
        /// Static method to implement Equatable manually
        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success(let lhsMeal), .success(let rhsMeal)):
                return lhsMeal.idMeal == rhsMeal.idMeal
            case (.error(let lhsMessage), .error(let rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
            }
        }
        
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
