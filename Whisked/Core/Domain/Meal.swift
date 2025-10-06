//
//  Meal.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation

/// Domain model representing a meal for the consumer layer
public struct Meal: Identifiable, Codable, Hashable, Sendable {
    
    // MARK: - Properties
    
    public let id: String
    public let name: String
    public let thumbnailURL: String
    
    // MARK: - Initializer
    
    public init(id: String, name: String, thumbnailURL: String) {
        self.id = id
        self.name = name
        self.thumbnailURL = thumbnailURL
    }
}