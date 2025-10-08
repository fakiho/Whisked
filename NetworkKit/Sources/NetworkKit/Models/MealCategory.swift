//
//  MealCategory.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Model representing a meal category from TheMealDB API
public struct MealCategory: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let id: String
    public let name: String
    public let description: String
    public let thumbnailURL: String
    
    // MARK: - Initializer
    
    public init(id: String, name: String, description: String, thumbnailURL: String) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case description = "strCategoryDescription"
        case thumbnailURL = "strCategoryThumb"
    }
}

// MARK: - MealCategory Extensions

public extension MealCategory {

    /// Static favorites category for showing user's favorite meals
    static let favorites: MealCategory = MealCategory(
        id: "favorites",
        name: "Favorites",
        description: "Your collection of favorite meals saved for offline viewing",
        thumbnailURL: "heart.fill" // Using SF Symbol name instead of URL for favorites
    )
}

/// Response model for the categories list API
public struct CategoriesResponse: Codable, Sendable {
    public let categories: [MealCategory]
    
    public init(categories: [MealCategory]) {
        self.categories = categories
    }
}
