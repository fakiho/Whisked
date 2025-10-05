//
//  WhiskedMainCoordinator.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI

/// Main coordinator responsible for managing the navigation flow in the Whisked application
@MainActor
@Observable
final class WhiskedMainCoordinator {
    
    // MARK: - Navigation State
    
    /// Navigation path for managing the navigation stack
    var navigationPath = NavigationPath()
    
    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Destinations
    
    /// Enumeration defining all possible navigation destinations in the app
    enum Destination: Hashable, Sendable {
        case categoryList
        case mealsByCategory(category: MealCategory)
        case dessertDetail(dessertId: String)
    }
    
    // MARK: - Initialization
    
    /// Initializes the coordinator with a network service
    /// - Parameter networkService: The network service for data operations
    init(networkService: NetworkServiceProtocol? = nil) {
        self.networkService = networkService ?? NetworkService()
    }
    
    // MARK: - Factory Methods
    
    /// Creates the main category list view with proper dependency injection
    /// - Returns: Configured CategoryListView
    func createCategoryListView() -> CategoryListView {
        return CategoryListView(coordinator: self, networkService: networkService)
    }
    
    /// Creates a meal list view for a specific category
    /// - Parameter category: The meal category to display
    /// - Returns: Configured WhiskedDessertListView with category filter
    func createMealsByCategoryView(category: MealCategory) -> WhiskedDessertListView {
        let viewModel = DessertListViewModel(networkService: networkService, category: category)
        return WhiskedDessertListView(
            coordinator: self, 
            viewModel: viewModel
        )
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
    
    /// Shows the dessert detail view for a specific dessert
    /// - Parameter dessertId: The unique identifier of the dessert
    func showDessertDetail(dessertId: String) {
        navigationPath.append(Destination.dessertDetail(dessertId: dessertId))
    }
    
    /// Pops to the root view (dessert list)
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
        case .dessertDetail(let dessertId):
            createDessertDetailView(mealID: dessertId)
        }
    }
    
    // MARK: - Private Factory Methods
    
    /// Creates the dessert detail view with proper dependency injection
    /// - Parameter mealID: The meal ID to display details for
    /// - Returns: Configured WhiskedDessertDetailView
    private func createDessertDetailView(mealID: String) -> WhiskedDessertDetailView {
        let viewModel = DessertDetailViewModel(mealID: mealID, networkService: networkService)
        return WhiskedDessertDetailView(
            mealID: mealID, 
            coordinator: self, 
            viewModel: viewModel
        )
    }
}
