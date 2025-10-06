//
//  FavoritesViewModel.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftUI
import PersistenceKit
import Combine

/// ViewModel managing favorites list state and business logic
@MainActor
final class FavoritesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var loadingState: LoadingState<[FavoriteMeal]> = .idle
    
    // MARK: - Private Properties
    
    private let persistenceService: PersistenceServiceProtocol?

    // MARK: - Initialization
    
    init(persistenceService: PersistenceServiceProtocol?) {
        self.persistenceService = persistenceService
    }
    
    // MARK: - Public Methods
    
    /// Loads all favorite meals from the persistence service
    func loadFavorites() async {
        guard let persistenceService = persistenceService else {
            loadingState = .loaded([])
            return
        }
        
        // Skip if already loading
        if case .loading = loadingState {
            return
        }
        
        loadingState = .loading
        
        do {
            let offlineMeals = try await persistenceService.fetchAllOfflineMeals()
            let favorites = offlineMeals.map { meal in
                let ingredients = meal.ingredients.map { tuple in
                    Ingredient(name: tuple.name, measure: tuple.measure)
                }
                return FavoriteMeal(
                    idMeal: meal.idMeal,
                    strMeal: meal.strMeal,
                    strMealThumb: meal.strMealThumb,
                    strInstructions: meal.strInstructions,
                    ingredients: ingredients,
                    dateSaved: meal.dateSaved
                )
            }
            loadingState = .loaded(favorites)
        } catch {
            loadingState = .failed(error)
        }
    }
    
    /// Refreshes the favorites list
    func refreshFavorites() async {
        await loadFavorites()
    }
    
    /// Removes a favorite meal by ID
    /// - Parameter mealID: The ID of the meal to remove from favorites
    func removeFavorite(_ mealID: String) async {
        guard let persistenceService = persistenceService else { return }
        
        do {
            try await persistenceService.deleteFavoriteMeal(by: mealID)
            // Refresh the list after removal
            await loadFavorites()
        } catch {
            // Could add error handling here if needed
            print("Failed to remove favorite: \(error)")
        }
    }
}
