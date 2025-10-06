//
//  PersistenceServiceProtocol.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Protocol for persistence service operations
public protocol PersistenceServiceProtocol: Sendable {
    func saveFavoriteMeal(idMeal: String, strMeal: String, strMealThumb: String, strInstructions: String, ingredients: [(name: String, measure: String)]) async throws
    func deleteFavoriteMeal(by idMeal: String) async throws
    func fetchFavoriteMeal(by idMeal: String) async throws -> OfflineMealData?
    func fetchFavoriteIDs() async throws -> Set<String>
    func getOfflineMealsCount() async throws -> Int
    func fetchAllOfflineMeals() async throws -> [OfflineMealData]
}
