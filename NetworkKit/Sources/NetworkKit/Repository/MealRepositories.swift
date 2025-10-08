//
//  MealRepositories.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation

public final class MealRepositories: MealRepositoryProtocol {

    let requester = NetworkService()

    public init() {}

    public func getSearchMeals(mealName: String) async throws -> MealsResponse {
        let request = MealRequest.searchMealByName(mealName)
        return try await  requester.request(from: request)
    }
    
    public func getMeals(by category: String) async throws -> [Meal] {
        let request = MealRequest.filterByCategory(category)
        let response: MealsResponse = try await requester.request(from: request)
        return response.meals
    }
    
    public func getMealDetail(mealID: String) async throws -> MealDetail {
        let request = MealRequest.lookupFullMealDetailsById(mealID)
        let response: MealDetailResponse = try await requester.request(from: request)
        
        guard let meals = response.meals, let meal = meals.first else {
            throw NetworkError.mealNotFound
        }
        
        return meal
    }

    public func getCategoryList() async throws -> [MealCategory] {
        let request = MealRequest.listAllMealCategories
        let response: CategoriesResponse = try await requester.request(from: request)
        return response.categories
    }
}
