//
//  CategoryListViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import Combine
import PersistenceKit

/// ViewModel managing category list state and business logic
@MainActor
final class CategoryListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var loadingState: LoadingState<[MealCategory]> = .idle
    @Published private(set) var selectedCategory: MealCategory?
    @Published private(set) var allCategories: [MealCategory] = []
    @Published private(set) var favoritesCount: Int = 0

    // MARK: - Private Properties
    private let persistenceService: PersistenceServiceProtocol?
    private let mealService: MealServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    
    init(mealService: MealServiceProtocol, persistenceService: PersistenceServiceProtocol?) {
        self.mealService = mealService
        self.persistenceService = persistenceService
    }
    
    // MARK: - Public Methods

    func load() async {
        await loadCategories()
        await loadFavoritesCount()
    }

    func refresh() async {
        await load()
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

    // MARK: - Private Methods

    /// Loads categories from the network service
    private func loadCategories() async {
        // Skip if already loading
        switch loadingState {
        case .loading:
            return
        case .idle, .failed, .loaded:
            break
        }

        loadingState = .loading
        do {
            let categories = try await mealService.fetchCategories()
            allCategories = categories
            loadingState = .loaded(categories)
        } catch {
            loadingState = .failed(error)
        }
    }

    /// Loads the count of favorite meals from persistence service
    private func loadFavoritesCount() async {
        guard let persistenceService = persistenceService else {
            favoritesCount = 0
            return
        }

        do {
            let count = try await persistenceService.getOfflineMealsCount()
            await MainActor.run {
                favoritesCount = count
            }
        } catch {
            await MainActor.run {
                favoritesCount = 0
            }
        }
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
