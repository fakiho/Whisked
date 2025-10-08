//
//  MealService.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation
import NetworkKit

/// Concrete implementation of MealServiceProtocol that bridges NetworkKit to domain models
final class MealService: MealServiceProtocol {
    
    // MARK: - Dependencies
    
    private let networkService: MealRepositoryProtocol
    
    // MARK: - Initialization
    
    /// Initializes the MealService with a NetworkKit service
    /// - Parameter networkService: The NetworkKit service for network operations
    init(networkService: NetworkKit.MealRepositoryProtocol = MealRepositories()) {
        self.networkService = networkService
    }
    
    // MARK: - MealServiceProtocol Implementation
    
    func fetchCategories() async throws -> [MealCategory] {
        do {
            let networkCategories = try await networkService.getCategoryList()
            return NetworkModelMapper.mapToMealCategories(networkCategories)
        } catch {
            throw NetworkModelMapper.mapErrorToMealServiceError(error)
        }
    }
    
    func fetchMealsByCategory(_ category: String) async throws -> [Meal] {
        do {
            let networkMeals = try await networkService.getMeals(by: category)
            return NetworkModelMapper.mapToMeals(networkMeals)
        } catch {
            throw NetworkModelMapper.mapErrorToMealServiceError(error)
        }
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail {
        do {
            let networkMealDetail = try await networkService.getMealDetail(mealID: id)
            return NetworkModelMapper.mapToMealDetail(networkMealDetail)
        } catch {
            throw NetworkModelMapper.mapErrorToMealServiceError(error)
        }
    }
}
