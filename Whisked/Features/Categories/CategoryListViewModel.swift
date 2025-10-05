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
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    /// Loads categories from the network service
    func loadCategories() async {
        // Skip if already loading or already loaded
        switch loadingState {
        case .loading, .loaded:
            return
        case .idle, .failed:
            break
        }
        
        loadingState = .loading
        
        do {
            let categories = try await networkService.fetchCategories()
            print("CategoryListViewModel: Loaded \(categories.count) categories")
            loadingState = .loaded(categories)
        } catch {
            print("CategoryListViewModel: Failed to load categories: \(error)")
            loadingState = .failed(error)
        }
    }
    
    /// Refreshes categories by reloading them
    func refreshCategories() async {
        loadingState = .loading
        
        do {
            let categories = try await networkService.fetchCategories()
            loadingState = .loaded(categories)
        } catch {
            loadingState = .failed(error)
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
