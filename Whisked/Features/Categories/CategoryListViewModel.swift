//
//  CategoryListViewModel.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/5/25.
//

import Foundation
import Combine

/// ViewModel managing category list state and business logic
@MainActor
final class CategoryListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var loadingState: LoadingState<[MealCategory]> = .idle
    @Published private(set) var selectedCategory: MealCategory?
    @Published private(set) var displayedCategories: [MealCategory] = []
    @Published private(set) var isLoadingMore: Bool = false
    @Published private(set) var hasMorePages: Bool = false
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allCategories: [MealCategory] = []
    private var currentPage: Int = 0
    private let pageSize: Int
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceProtocol = NetworkService(), pageSize: Int = 10) {
        self.networkService = networkService
        self.pageSize = pageSize
    }
    
    // MARK: - Public Methods
    
    /// Loads categories from the network service
    func loadCategories() async {
        // Skip if already loading
        switch loadingState {
        case .loading:
            return
        case .idle, .failed, .loaded:
            break
        }
        
        loadingState = .loading
        currentPage = 0
        displayedCategories = []
        
        do {
            let categories = try await networkService.fetchCategories()
            allCategories = categories
            hasMorePages = categories.count > pageSize
            loadNextPage()
            loadingState = .loaded(categories)
        } catch {
            loadingState = .failed(error)
        }
    }
    
    /// Refreshes categories by reloading them
    func refreshCategories() async {
        loadingState = .loading
        currentPage = 0
        displayedCategories = []
        
        do {
            let categories = try await networkService.fetchCategories()
            allCategories = categories
            hasMorePages = categories.count > pageSize
            loadNextPage()
            loadingState = .loaded(categories)
        } catch {
            loadingState = .failed(error)
        }
    }
    
    /// Loads the next page of categories
    func loadNextPage() {
        guard !isLoadingMore else { return }
        
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allCategories.count)
        
        guard startIndex < allCategories.count else { return }
        
        // For subsequent pages (not the first), check if there are more pages
        if currentPage > 0 && !hasMorePages {
            return
        }
        
        isLoadingMore = true
        
        // For the first page, load immediately. For subsequent pages, add delay for better UX
        let delay = currentPage == 0 ? 0.0 : 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            let nextPageCategories = Array(self.allCategories[startIndex..<endIndex])
            self.displayedCategories.append(contentsOf: nextPageCategories)
            self.currentPage += 1
            self.hasMorePages = endIndex < self.allCategories.count
            self.isLoadingMore = false
        }
    }
    
    /// Checks if we should load more categories when reaching near the end
    func checkForLoadMore(category: MealCategory) {
        // Load more when we're 3 items from the end
        if let index = displayedCategories.firstIndex(where: { $0.id == category.id }),
           index >= displayedCategories.count - 3 {
            loadNextPage()
        }
    }
    
    /// Selects a category for navigation
    func selectCategory(_ category: MealCategory) {
        selectedCategory = category
        // Navigation will be handled by the coordinator
    }
    
    /// Clears the selected category
    func clearSelection() {
        selectedCategory = nil
    }
}

// MARK: - Loading State

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}

// MARK: - LoadingState Equatable

extension LoadingState: Equatable where T: Equatable {
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsValue), .loaded(let rhsValue)):
            return lhsValue == rhsValue
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
