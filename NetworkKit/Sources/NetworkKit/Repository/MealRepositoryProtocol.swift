//
//  MealRepositoryProtocol.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//


public protocol MealRepositoryProtocol: Sendable {
    func getMeals(by category: String) async throws -> [Meal]
    func getCategoryList() async throws -> [MealCategory]
    func getMealDetail(mealID: String) async throws -> MealDetail
}
