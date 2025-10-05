import Foundation

/// Protocol for persistence service operations
protocol PersistenceServiceProtocol {
    func saveFavoriteMeal(idMeal: String, strMeal: String, strMealThumb: String, strInstructions: String, ingredients: [(name: String, measure: String)]) async throws
    func deleteFavoriteMeal(by idMeal: String) async throws
    func fetchFavoriteMeal(by idMeal: String) async throws -> (idMeal: String, strMeal: String, strMealThumb: String, strInstructions: String, ingredients: [(name: String, measure: String)])?
    func fetchFavoriteIDs() async throws -> Set<String>
}