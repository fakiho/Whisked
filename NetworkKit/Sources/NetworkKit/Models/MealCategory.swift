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
    
    // MARK: - Static Categories
    
    /// Predefined categories that we know work well with the API
    public static let supportedCategories: [MealCategory] = [
        MealCategory(
            id: "1",
            name: "Dessert",
            description: "Sweet treats and desserts from around the world",
            thumbnailURL: "https://www.themealdb.com/images/category/dessert.png"
        ),
        MealCategory(
            id: "2", 
            name: "Breakfast",
            description: "Start your day right with these breakfast recipes",
            thumbnailURL: "https://www.themealdb.com/images/category/breakfast.png"
        ),
        MealCategory(
            id: "3",
            name: "Chicken",
            description: "Delicious chicken dishes from various cuisines",
            thumbnailURL: "https://www.themealdb.com/images/category/chicken.png"
        ),
        MealCategory(
            id: "4",
            name: "Pasta",
            description: "Italian pasta dishes and noodle recipes",
            thumbnailURL: "https://www.themealdb.com/images/category/pasta.png"
        ),
        MealCategory(
            id: "5",
            name: "Seafood",
            description: "Fresh seafood and fish recipes",
            thumbnailURL: "https://www.themealdb.com/images/category/seafood.png"
        )
    ]
}

// MARK: - MealCategory Extensions

public extension MealCategory {
    
    /// Static dessert category with detailed description for preview purposes
    static let dessert: MealCategory = MealCategory(
        id: "3",
        name: "Dessert",
        description: "Dessert is a course that concludes a meal. The course usually consists of sweet foods, such as confections dishes or fruit, and possibly a beverage such as dessert wine or liqueur, however in the United States it may include coffee, cheeses, nuts, or other savory items regarded as a separate course elsewhere. In some parts of the world, such as much of central and western Africa, and most parts of China, there is no tradition of a dessert course to conclude a meal.\r\n\r\nThe term dessert can apply to many confections, such as biscuits, cakes, cookies, custards, gelatins, ice creams, pastries, pies, puddings, and sweet soups, and tarts. Fruit is also commonly found in dessert courses because of its naturally occurring sweetness. Some cultures sweeten foods that are more commonly savory to create desserts.",
        thumbnailURL: "https://www.themealdb.com/images/category/dessert.png"
    )
    
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