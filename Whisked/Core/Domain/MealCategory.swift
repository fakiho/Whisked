//
//  MealCategory.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Domain model representing a meal category for the consumer layer
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
}

// MARK: - MealCategory Extensions

public extension MealCategory {
    
    /// Static dessert category for common usage
    static let dessert: MealCategory = MealCategory(
        id: "3",
        name: "Dessert",
        description: "Dessert is a course that concludes a meal. The course usually consists of sweet foods, such as confections dishes or fruit, and possibly a beverage such as dessert wine or liqueur, however in the United States it may include coffee, cheeses, nuts, or other savory items regarded as a separate course elsewhere. In some parts of the world, such as much of central and western Africa, and most parts of China, there is no tradition of a dessert course to conclude a meal.\r\n\r\nThe term dessert can apply to many confections, such as biscuits, cakes, cookies, custards, gelatins, ice creams, pastries, pies, puddings, and sweet soups, and tarts. Fruit is also commonly found in dessert courses because of its naturally occurring sweetness. Some cultures sweeten foods that are more commonly savory to create desserts.",
        thumbnailURL: "https://www.themealdb.com/images/category/dessert.png"
    )
    
    /// Static favorites category for user's saved meals
    static let favorites: MealCategory = MealCategory(
        id: "favorites",
        name: "Favorites",
        description: "Your collection of favorite meals saved for offline viewing",
        thumbnailURL: "heart.fill"
    )
}