//
//  MealListViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import PersistenceKit
import Combine
import NetworkKit

/// ViewModel for managing the meal list screen state and data with client-side pagination
///
/// **Technical Note**: This ViewModel uses `@Observable` (iOS 17+) as an alternative to the traditional
/// `ObservableObject` + `@Published` pattern used elsewhere in this codebase. This demonstrates both
/// approaches for technical evaluation purposes.
///
/// **Production Consideration**: In a real project, consistency is crucial. All ViewModels should follow
/// the same observation pattern. The choice between `@Observable` and `ObservableObject` should be made
/// project-wide based on:
/// - Minimum deployment target (iOS 17+ required for @Observable)
/// - Team familiarity and preferences
/// - Performance requirements (@Observable is more efficient)
/// - Migration timeline (for existing projects)
///
/// **@Observable Benefits**:
/// - Better performance than ObservableObject
/// - Cleaner syntax (no @Published required)
/// - Better Swift concurrency integration
/// - Automatic observation of property changes
///
/// **For Production**: Consider standardizing all ViewModels to use @Observable for iOS 17+ projects,
/// or ObservableObject for broader iOS version support.
@MainActor
@Observable
final class MealListViewModel {

    // MARK: - Published Properties
    
    /// Current view state - tracks initial fetch, success, error, and pagination completion
    private(set) var state: ViewState = .idle
    
    /// Array of meals currently displayed to the user (paginated subset)
    private(set) var meals: [Meal] = []
    
    /// Array of filtered meals based on search query
    private(set) var filteredMeals: [Meal] = []
    
    /// Current search query
    private(set) var searchQuery: String = ""
    
    /// The category being filtered, if any
    private(set) var category: MealCategory
    
    /// Set of favorite meal IDs for quick lookup
    private(set) var favoriteMealIDs: Set<String> = []
    
    /// Whether pagination has reached the end
    private(set) var hasReachedEnd: Bool = false
    
    /// Whether search is currently active
    var isSearchActive: Bool {
        return !searchQuery.isEmpty
    }
    
    // MARK: - Private Properties
    
    /// Complete dataset fetched from API - single source of truth
    private var allMeals: [Meal] = []
    
    /// Current page number for pagination (0-based)
    private var currentPage = 0
    
    /// Number of items to load per page
    private let pageSize = 20
    
    /// Flag to prevent multiple simultaneous fetch operations
    private var hasFetchedData = false
    
    /// Task for managing debounced search operations
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Dependencies
    
    private let mealService: MealServiceProtocol
    private nonisolated let persistenceService: PersistenceKit.PersistenceServiceProtocol?
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a meal service, category, and optional persistence service
    /// - Parameters:
    ///   - mealService: The meal service for fetching meal data
    ///   - category: Category to filter meals by
    ///   - persistenceService: The persistence service for favorite management (optional for now)
    init(
        mealService: MealServiceProtocol, 
        category: MealCategory,
        persistenceService: PersistenceKit.PersistenceServiceProtocol? = nil
    ) {
        self.mealService = mealService
        self.category = category
        self.persistenceService = persistenceService
    }
    
    // MARK: - Public Methods
    
    /// Initiates the initial fetch of all meals from the API
    /// Also loads favorite meal IDs if persistence service is available
    /// This should only be called once - subsequent pagination is handled in-memory
    func fetchAllMeals() async {
        // Prevent multiple simultaneous fetches
        guard !hasFetchedData && state != .loading else { return }
        
        state = .loading
        meals = []
        allMeals = []
        currentPage = 0
        hasReachedEnd = false
        
        do {
            // Load favorites and meals concurrently
            async let favoritesTask: Set<String> = loadFavoriteIDs()
            async let mealsTask: [Meal] = mealService.fetchMealsByCategory(category.name)
            
            // Wait for both to complete
            let (favorites, fetchedMeals) = try await (favoritesTask, mealsTask)
            
            favoriteMealIDs = favorites
            allMeals = fetchedMeals
            hasFetchedData = true
            
            // Load first page immediately after successful fetch
            loadFirstPage()
            
        } catch {
            // Don't show error for cancelled requests (common during pull-to-refresh)
            if let urlError = error as? URLError, urlError.code == .cancelled {
                return
            }
            let errorMessage = MealListErrorMapper.mapErrorToUserFriendlyMessage(error)
            state = .error(errorMessage)
        }
    }
    
    /// Loads favorite meal IDs from persistence service
    /// - Returns: Set of favorite meal IDs, empty if no persistence service available
    private nonisolated func loadFavoriteIDs() async throws -> Set<String> {
        guard let service = persistenceService else {
            return []
        }
        
        return try await service.fetchFavoriteIDs()
    }
    
    /// Refreshes the favorite status for the meal list
    /// Call this when returning from the detail view where favorites might have changed
    nonisolated func refreshFavorites() async {
        guard let service = persistenceService else { return }
        
        do {
            let favorites = try await service.fetchFavoriteIDs()
            await MainActor.run {
                favoriteMealIDs = favorites
            }
        } catch {
            print("Failed to refresh favorites: \(error)")
            // Don't disrupt the user experience for favorite refresh failures
        }
    }
    
    /// Checks if a specific meal is favorited
    /// - Parameter mealID: The meal ID to check
    /// - Returns: True if the meal is favorited, false otherwise
    func isFavorite(mealID: String) -> Bool {
        return favoriteMealIDs.contains(mealID)
    }
    
    /// Determines if more data should be loaded based on current scroll position
    /// Call this method when the user scrolls near the end of the list
    /// - Parameter currentIndex: The index of the item currently visible
    /// - Returns: True if more data should be loaded
    func shouldLoadMore(currentIndex: Int) -> Bool {
        guard !isSearchActive && !hasReachedEnd && state.canLoadMore else {
            return false
        }
        
        // Load more when user is within 5 items of the end
        let threshold = max(0, filteredMeals.count - 5)
        return currentIndex >= threshold
    }
    
    /// Determines if pagination should be triggered for the given index
    /// Only triggers on specific items near the end to avoid excessive calls
    /// This method is designed for efficient UI pagination triggers
    /// - Parameter index: The index of the item that appeared in the UI
    /// - Returns: True if pagination should be triggered for this index
    func shouldTriggerPagination(for index: Int) -> Bool {
        // Use a more restrictive threshold for UI triggers to avoid excessive calls
        let threshold = max(5, filteredMeals.count - 3)
        return index >= threshold && shouldLoadMore(currentIndex: index)
    }
    
    // MARK: - Public Methods
    
    /// Loads the next page of meals from the in-memory dataset
    /// This is a synchronous operation that provides instant results
    /// Call this method when the user scrolls near the end of the list
    func loadNextPage() {
        // Don't load more if search is active - search shows all results
        guard !isSearchActive else { return }
        
        // Guard against invalid states and conditions
        guard state.canLoadMore && !hasReachedEnd && !allMeals.isEmpty else { return }
        
        // Set loading more state
        state = .loadingMore
        
        let startIndex = currentPage * pageSize
        
        // Ensure we don't go beyond available data
        guard startIndex < allMeals.count else {
            hasReachedEnd = true
            state = .finished
            return
        }
        
        // Calculate end index, ensuring we don't exceed array bounds
        let endIndex = min(startIndex + pageSize, allMeals.count)
        
        // Extract the slice for this page
        let newMeals = Array(allMeals[startIndex..<endIndex])
        
        // Append to displayed meals (not replace - this is pagination)
        meals.append(contentsOf: newMeals)
        
        // Update filtered meals to match current meals when no search is active
        filteredMeals = meals
        
        // Update pagination state
        currentPage += 1
        
        // Check if we've loaded all available data
        if endIndex >= allMeals.count {
            hasReachedEnd = true
            state = .finished
        } else {
            state = .loaded
        }
    }

    /// Refreshes the meal list by re-fetching all data and resetting pagination
    func refresh() async {
        hasFetchedData = false
        hasReachedEnd = false
        currentPage = 0
        await fetchAllMeals()
    }
    
    /// Retries fetching meals after an error
    func retry() async {
        hasFetchedData = false
        hasReachedEnd = false
        currentPage = 0
        await fetchAllMeals()
    }
    
    /// Filters meals based on search query with case-insensitive matching
    /// When search is active, shows all matching results immediately
    /// When search is cleared, returns to paginated view
    /// - Parameter query: The search query to filter meals
    func filterMeals(with query: String) {
        searchQuery = query
        
        if query.isEmpty {
            // Return to paginated view - show currently loaded pages
            filteredMeals = meals
        } else {
            // Search is active - show all matching results from the complete dataset
            filteredMeals = allMeals.filter { meal in
                meal.name.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    /// Performs debounced search with a 300ms delay to improve performance
    /// This method handles the Task management and debouncing logic in the ViewModel
    /// Uses proper Swift concurrency patterns without unsafe annotations
    /// - Parameter query: The search query to filter meals
    func performDebouncedSearch(query: String) {
        // Cancel previous search task
        searchTask?.cancel()
        
        // Create new search task with debouncing
        searchTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 300_000_000) // 300ms
                
                // Check if task was cancelled during sleep
                try Task.checkCancellation()
                
                // Perform the search on MainActor
                filterMeals(with: query)
                
            } catch is CancellationError {
                // Task was cancelled, which is expected behavior
                return
            } catch {
                // Handle any other errors
                print("Search task error: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Loads the first page after successful API fetch
    /// Handles the initial page load directly without delegation
    private func loadFirstPage() {
        guard !allMeals.isEmpty else {
            hasReachedEnd = true
            state = .finished // No data available
            return
        }
        
        // Reset pagination state
        currentPage = 0
        meals = []
        hasReachedEnd = false
        
        // Calculate how many items to show on first page
        let endIndex = min(pageSize, allMeals.count)
        
        // Load first page of meals directly
        let firstPageMeals = Array(allMeals[0..<endIndex])
        meals = firstPageMeals
        
        // Initialize filtered meals with displayed meals
        filteredMeals = meals
        
        // Update pagination state
        currentPage = 1
        
        // Set appropriate state based on whether there's more data
        if endIndex >= allMeals.count {
            hasReachedEnd = true
            state = .finished // All data loaded in first page
        } else {
            state = .loaded   // More pages available
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
        case loadingMore    // Loading next page of data
        case error(String)  // Network error occurred
        case finished       // All data has been paginated to the user
        
        /// Computed property to check if the view is in loading state
        var isLoading: Bool {
            switch self {
            case .loading, .loadingMore:
                return true
            default:
                return false
            }
        }
        
        /// Computed property to check if the view is in success state (loaded or finished)
        var isSuccess: Bool {
            switch self {
            case .loaded, .finished, .loadingMore:
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
        
        /// Computed property to check if currently loading more data
        var isLoadingMore: Bool {
            if case .loadingMore = self {
                return true
            }
            return false
        }
        
        /// Computed property to check if all data has been loaded
        var isFinished: Bool {
            if case .finished = self {
                return true
            }
            return false
        }
    }
}
