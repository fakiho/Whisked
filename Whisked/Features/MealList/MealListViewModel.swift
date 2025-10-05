//
//  MealListViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// ViewModel for managing the meal list screen state and data with client-side pagination
@MainActor
@Observable
final class MealListViewModel {

    // MARK: - Published Properties
    
    /// Current view state - tracks initial fetch, success, error, and pagination completion
    private(set) var state: ViewState = .idle
    
    /// Array of meals currently displayed to the user (paginated subset)
    private(set) var meals: [Meal] = []
    
    /// The category being filtered, if any
    private(set) var category: MealCategory
    
    // MARK: - Private Properties
    
    /// Complete dataset fetched from API - single source of truth
    private var allMeals: [Meal] = []
    
    /// Current page number for pagination (0-based)
    private var currentPage = 0
    
    /// Number of items to load per page
    private let pageSize = 20
    
    /// Flag to prevent multiple simultaneous fetch operations
    private var hasFetchedData = false
    
    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a network service and category
    /// - Parameters:
    ///   - networkService: The network service for fetching meal data
    ///   - category: Category to filter meals by
    init(networkService: NetworkServiceProtocol, category: MealCategory) {
        self.networkService = networkService
        self.category = category
    }
    
    // MARK: - Public Methods
    
    /// Initiates the initial fetch of all meals from the API
    /// This should only be called once - subsequent pagination is handled in-memory
    func fetchAllMeals() async {
        // Prevent multiple simultaneous fetches
        guard !hasFetchedData && state != .loading else { return }
        
        state = .loading
        meals = []
        allMeals = []
        currentPage = 0
        
        do {
            let fetchedMeals = try await networkService.fetchMealsByCategory(category.name)
            allMeals = fetchedMeals
            hasFetchedData = true
            
            // Load first page immediately after successful fetch
            loadFirstPage()
            
        } catch {
            // Don't show error for cancelled requests (common during pull-to-refresh)
            if let urlError = error as? URLError, urlError.code == .cancelled {
                return
            }
            let errorMessage = mapErrorToUserFriendlyMessage(error)
            state = .error(errorMessage)
        }
    }
    
    /// Loads the next page of meals from the in-memory dataset
    /// This is a synchronous operation that provides instant results
    func loadNextPage() {
        // Guard against invalid states and conditions
        guard state.canLoadMore,
              !allMeals.isEmpty else { return }
        
        let startIndex = currentPage * pageSize
        
        // Ensure we don't go beyond available data
        guard startIndex < allMeals.count else {
            state = .finished
            return
        }
        
        // Calculate end index, ensuring we don't exceed array bounds
        let endIndex = min(startIndex + pageSize, allMeals.count)
        
        // Extract the slice for this page
        let newMeals = Array(allMeals[startIndex..<endIndex])
        
        // Append to displayed meals (not replace - this is pagination)
        meals.append(contentsOf: newMeals)
        
        // Update pagination state
        currentPage += 1
        
        // Check if we've loaded all available data
        if endIndex >= allMeals.count {
            state = .finished
        } else {
            state = .loaded
        }
    }

    /// Refreshes the meal list by re-fetching all data and resetting pagination
    func refresh() async {
        hasFetchedData = false
        await fetchAllMeals()
    }
    
    /// Retries fetching meals after an error
    func retry() async {
        hasFetchedData = false
        await fetchAllMeals()
    }
    
    // MARK: - Private Methods
    
    /// Loads the first page after successful API fetch
    /// Handles the initial page load directly without delegation
    private func loadFirstPage() {
        guard !allMeals.isEmpty else {
            state = .finished // No data available
            return
        }
        
        // Reset pagination state
        currentPage = 0
        meals = []
        
        // Calculate how many items to show on first page
        let endIndex = min(pageSize, allMeals.count)
        
        // Load first page of meals directly
        let firstPageMeals = Array(allMeals[0..<endIndex])
        meals = firstPageMeals
        
        // Update pagination state
        currentPage = 1
        
        // Set appropriate state based on whether there's more data
        if endIndex >= allMeals.count {
            state = .finished // All data loaded in first page
        } else {
            state = .loaded   // More pages available
        }
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
                return "No meals found. Please try again later."
            default:
                return "Something went wrong. Please try again."
            }
        } else {
            return "An unexpected error occurred. Please try again."
        }
    }
}

// MARK: - ViewState

extension MealListViewModel {

    /// Enumeration representing the possible states of the meal list view with pagination support
    enum ViewState: Equatable, Sendable {
        case idle           // Initial state before any network call
        case loading        // Fetching complete dataset from API
        case loaded         // Successfully loaded, pagination may continue
        case error(String)  // Network error occurred
        case finished       // All data has been paginated to the user
        
        /// Computed property to check if the view is in loading state
        var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
        
        /// Computed property to check if the view is in success state (loaded or finished)
        var isSuccess: Bool {
            switch self {
            case .loaded, .finished:
                return true
            default:
                return false
            }
        }
        
        /// Computed property to get error message if in error state
        var errorMessage: String? {
            if case .error(let message) = self {
                return message
            }
            return nil
        }
        
        /// Computed property to check if pagination can continue
        var canLoadMore: Bool {
            if case .loaded = self {
                return true
            }
            return false
        }
    }
}
