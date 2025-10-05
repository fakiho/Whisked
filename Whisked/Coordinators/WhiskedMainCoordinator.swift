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
        case dessertDetail(dessertId: String)
    }
    
    // MARK: - Initialization
    
    /// Initializes the coordinator with a network service
    /// - Parameter networkService: The network service for data operations
    init(networkService: NetworkServiceProtocol? = nil) {
        self.networkService = networkService ?? NetworkService()
    }
    
    // MARK: - Factory Methods
    
    /// Creates the main dessert list view with proper dependency injection
    /// - Parameter heroAnimationNamespace: Namespace for hero animations
    /// - Returns: Configured WhiskedDessertListView
    func createDessertListView(heroAnimationNamespace: Namespace.ID) -> WhiskedDessertListView {
        let viewModel = DessertListViewModel(networkService: networkService)
        return WhiskedDessertListView(
            coordinator: self, 
            viewModel: viewModel,
            heroAnimationNamespace: heroAnimationNamespace
        )
    }
    
    // MARK: - Navigation Methods
    
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
    /// - Parameters:
    ///   - destination: The destination to create a view for
    ///   - heroAnimationNamespace: Namespace for hero animations
    /// - Returns: The SwiftUI view for the destination
    @ViewBuilder
    func view(for destination: Destination, heroAnimationNamespace: Namespace.ID) -> some View {
        switch destination {
        case .dessertDetail(let dessertId):
            createDessertDetailView(mealID: dessertId, heroAnimationNamespace: heroAnimationNamespace)
        }
    }
    
    // MARK: - Legacy Support
    
    /// Creates the appropriate view for the given destination (legacy method)
    /// - Parameter destination: The destination to create a view for
    /// - Returns: The SwiftUI view for the destination
    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .dessertDetail(let dessertId):
            // Create a temporary namespace for legacy support
            let tempView = createLegacyDessertDetailView(mealID: dessertId)
            tempView
        }
    }
    
    // MARK: - Private Factory Methods
    
    /// Creates the dessert detail view with proper dependency injection and hero animation support
    /// - Parameters:
    ///   - mealID: The meal ID to display details for
    ///   - heroAnimationNamespace: Namespace for hero animations
    /// - Returns: Configured WhiskedDessertDetailView
    private func createDessertDetailView(
        mealID: String, 
        heroAnimationNamespace: Namespace.ID
    ) -> WhiskedDessertDetailView {
        let viewModel = DessertDetailViewModel(mealID: mealID, networkService: networkService)
        return WhiskedDessertDetailView(
            mealID: mealID, 
            coordinator: self, 
            viewModel: viewModel,
            heroAnimationNamespace: heroAnimationNamespace
        )
    }
    
    /// Creates the dessert detail view without hero animation (legacy support)
    /// - Parameter mealID: The meal ID to display details for
    /// - Returns: Configured WhiskedDessertDetailView
    private func createLegacyDessertDetailView(mealID: String) -> WhiskedDessertDetailView {
        let viewModel = DessertDetailViewModel(mealID: mealID, networkService: networkService)
        return WhiskedDessertDetailView(
            mealID: mealID, 
            coordinator: self, 
            viewModel: viewModel,
            heroAnimationNamespace: nil
        )
    }
}