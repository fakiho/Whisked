//
//  FavoriteDessert.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation
import SwiftData

/// SwiftData model representing a favorite dessert
@Model
public final class FavoriteDessert {
    
    /// Unique identifier for the meal
    @Attribute(.unique) public var idMeal: String
    
    /// Date when the dessert was added to favorites
    public var dateAdded: Date
    
    /// Initializes a new favorite dessert
    /// - Parameters:
    ///   - idMeal: The unique identifier of the meal
    ///   - dateAdded: The date when the dessert was added to favorites (defaults to current date)
    public init(idMeal: String, dateAdded: Date = Date()) {
        self.idMeal = idMeal
        self.dateAdded = dateAdded
    }
}

// MARK: - Comparable

extension FavoriteDessert: Comparable {
    public static func < (lhs: FavoriteDessert, rhs: FavoriteDessert) -> Bool {
        lhs.dateAdded < rhs.dateAdded
    }
}

// MARK: - Identifiable

extension FavoriteDessert: Identifiable {
    public var id: String { idMeal }
}