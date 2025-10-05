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
    enum Destination: Hashable {
        case dessertDetail(dessertId: String)
    }
    
    // MARK: - Initialization
    
    /// Initializes the coordinator with a network service
    /// - Parameter networkService: The network service for data operations
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Factory Methods
    
    /// Creates the main dessert list view with proper dependency injection
    /// - Returns: Configured WhiskedDessertListView
    func createDessertListView() -> WhiskedDessertListView {
        let viewModel = DessertListViewModel(networkService: networkService)
        return WhiskedDessertListView(coordinator: self, viewModel: viewModel)
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
    /// - Parameter destination: The destination to create a view for
    /// - Returns: The SwiftUI view for the destination
    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .dessertDetail(let dessertId):
            WhiskedDessertDetailView(dessertId: dessertId, coordinator: self)
        }
    }
}