//
//  MealListViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// ViewModel for managing the meal list screen state and data
@MainActor
@Observable
final class MealListViewModel {

    // MARK: - Published Properties
    
    /// Current view state
    private(set) var state: ViewState = .loading
    
    /// Array of meals currently displayed (paginated)
    private(set) var meals: [Meal] = []
    
    /// Loading state for pagination
    private(set) var isLoadingMore: Bool = false
    
    /// Whether there are more pages to load
    private(set) var hasMorePages: Bool = false
    
    /// The category being filtered, if any
    private(set) var category: MealCategory
    
    // MARK: - Private Properties
    
    private var allMeals: [Meal] = []
    private var currentPage: Int = 0
    private let pageSize: Int
    
    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a network service and optional category
    /// - Parameters:
    ///   - networkService: The network service for fetching meal data
    ///   - category: Optional category to filter meals by
    ///   - pageSize: Number of items per page (default: 15)
    init(networkService: NetworkServiceProtocol, category: MealCategory, pageSize: Int = 15) {
        self.networkService = networkService
        self.category = category
        self.pageSize = pageSize
    }
    
    // MARK: - Public Methods
    
    /// Fetches meals from the API based on category and updates the view state
    func fetchMeals() async {
        state = .loading
        currentPage = 0
        meals = []
        
        do {
            let fetchedMeals = try await networkService.fetchMealsByCategory(category.name)
            allMeals = fetchedMeals
            hasMorePages = fetchedMeals.count > pageSize
            
            // Load first page immediately for initial load
            let startIndex = 0
            let endIndex = min(pageSize, allMeals.count)
            if endIndex > 0 {
                meals = Array(allMeals[startIndex..<endIndex])
                currentPage = 1
            }
            
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
        currentPage = 0
        meals = []
        
        do {
            let fetchedMeals = try await networkService.fetchMealsByCategory(category.name)
            allMeals = fetchedMeals
            hasMorePages = fetchedMeals.count > pageSize
            
            // Load first page immediately for refresh
            let startIndex = 0
            let endIndex = min(pageSize, allMeals.count)
            if endIndex > 0 {
                meals = Array(allMeals[startIndex..<endIndex])
                currentPage = 1
            }
            
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
    
    /// Loads the next page of meals
    func loadMoreMeals() {
        guard !isLoadingMore && hasMorePages && state.isSuccess else { return }
        loadNextPage()
    }
    
    /// Checks if we should load more meals when reaching near the end
    func checkForLoadMore(meal: Meal) {
        // Load more when we're 3 items from the end
        if let index = meals.firstIndex(where: { $0.id == meal.id }),
           index >= meals.count - 3 {
            loadMoreMeals()
        }
    }
    
    // MARK: - Private Methods
    
    /// Loads the next page of meals from allMeals array
    private func loadNextPage() {
        guard !isLoadingMore else { return }
        
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allMeals.count)
        
        guard startIndex < allMeals.count else { return }
        
        isLoadingMore = true
        
        // Simulate loading delay for better UX (only for subsequent pages)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let nextPageMeals = Array(self.allMeals[startIndex..<endIndex])
            self.meals.append(contentsOf: nextPageMeals)
            self.currentPage += 1
            self.hasMorePages = endIndex < self.allMeals.count
            self.isLoadingMore = false
        }
    }
    
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
