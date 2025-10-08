//
//  WhiskedMainCoordinator.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import PersistenceKit
import Combine

/// Main coordinator responsible for managing the navigation flow in the Whisked application
@MainActor
final class WhiskedMainCoordinator: ObservableObject {
    
    // MARK: - Navigation State
    
    /// Navigation path for managing the navigation stack
    @Published var navigationPath = NavigationPath()
    
    // MARK: - Dependencies
    
    private let mealService: MealServiceProtocol
    
    /// Persistence service for managing offline favorites
    private let persistenceService: PersistenceService

    // MARK: - Destinations
    
    /// Enumeration defining all possible navigation destinations in the app
    enum Destination: Hashable, Sendable {
        case categoryList
        case mealsByCategory(category: MealCategory)
        case mealDetail(mealId: String)
        case favorites
    }
    
    // MARK: - Initialization
    
    /// Initializes the coordinator with a meal service
    /// - Parameter mealService: The meal service for data operations
    init(mealService: MealServiceProtocol? = nil) {
        self.mealService = mealService ?? MealService()
        
        // Initialize persistence service with ModelContainer for @ModelActor
        let contextManager = SwiftDataContextManager.shared
        guard let container = contextManager.container else {
            fatalError("Could not get container from SwiftDataContextManager")
        }
        self.persistenceService = PersistenceService(modelContainer: container)
    }
    
    // MARK: - Factory Methods
    
    /// Creates the main category list view with proper dependency injection
    /// - Returns: Configured CategoryListView
    func createCategoryListView() -> CategoryListView {
        return CategoryListView(
            viewModel: CategoryListViewModel(
                mealService: mealService,
                persistenceService: persistenceService,
                coordinator: self
            )
        )
    }
    
    /// Creates a meal list view for a specific category
    /// - Parameter category: The meal category to display
    /// - Returns: Configured MealListView with category filter
    func createMealsByCategoryView(category: MealCategory) -> MealListView {
        let viewModel = MealListViewModel(
            mealService: mealService, 
            category: category, 
            persistenceService: persistenceService
        )
        return MealListView(
            coordinator: self,
            viewModel: viewModel
        )
    }
    
    /// Creates the favorites view showing all saved favorite meals
    /// - Returns: Configured FavoritesView
    func createFavoritesView() -> FavoritesView {
        return FavoritesView(coordinator: self, persistenceService: persistenceService)
    }
    
    // MARK: - Navigation Methods
    
    /// Shows the category list view
    func showCategoryList() {
        navigationPath.append(Destination.categoryList)
    }
    
    /// Shows the meals for a specific category
    /// - Parameter category: The meal category to display
    func showMealsByCategory(_ category: MealCategory) {
        navigationPath.append(Destination.mealsByCategory(category: category))
    }
    
    /// Shows the meal detail view for a specific category
    /// - Parameter mealId: The unique identifier of the meal
    func showMealDetail(mealId: String) {
        navigationPath.append(Destination.mealDetail(mealId: mealId))
    }
    
    /// Shows the favorites view with all saved favorite meals
    func showFavorites() {
        navigationPath.append(Destination.favorites)
    }
    
    /// Pops to the root view (meal list)
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    /// Pops the current view from the navigation stack
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    /// Creates the appropriate view for the given destination
    /// - Parameter destination: The destination to create a view for
    /// - Returns: The SwiftUI view for the destination
    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .categoryList:
            createCategoryListView()
        case .mealsByCategory(let category):
            createMealsByCategoryView(category: category)
        case .mealDetail(let mealId):
            createMealDetailView(mealID: mealId)
        case .favorites:
            createFavoritesView()
        }
    }
    
    // MARK: - Private Factory Methods
    
    /// Creates the meal detail view with proper dependency injection
    /// - Parameter mealID: The meal ID to display details for
    /// - Returns: Configured MealDetailView
    private func createMealDetailView(mealID: String) -> MealDetailView {
        let viewModel = MealDetailViewModel(
            mealID: mealID, 
            mealService: mealService,
            persistenceService: persistenceService
        )
        return MealDetailView(
            mealID: mealID, 
            coordinator: self, 
            viewModel: viewModel
        )
    }
}
