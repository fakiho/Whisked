//
//  MealLocalDataSource.swift
//  PersistenceKit
//
//  Created by Ali FAKIH on 10/6/25.
//

import Foundation
import SwiftData

/// Data Access Object for managing OfflineMeal entities in SwiftData
/// This class encapsulates all SwiftData operations and can be easily unit tested
@MainActor
public class MealLocalDataSource {
    
    // MARK: - Properties
    
    private let container: ModelContainer?
    private let context: ModelContext?
    
    // MARK: - Initialization
    
    /// Initializes the data source with a container and context
    /// - Parameters:
    ///   - container: The ModelContainer for SwiftData operations
    ///   - context: The ModelContext for SwiftData operations
    public init(container: ModelContainer?, context: ModelContext?) {
        self.container = container
        self.context = context
    }
}

// MARK: - CRUD Operations

extension MealLocalDataSource {
    
    /// Inserts a new OfflineMeal entity into the database
    /// - Parameter entity: The OfflineMeal entity to insert
    public func insert(_ entity: OfflineMeal) {
        guard let context = self.context else { return }
        context.insert(entity)
        try? context.save()
    }
    
    /// Deletes an OfflineMeal entity from the database
    /// - Parameter entity: The OfflineMeal entity to delete
    public func delete(_ entity: OfflineMeal) {
        guard let context = self.context else { return }
        context.delete(entity)
        try? context.save()
    }
    
    /// Deletes an OfflineMeal entity by its ID
    /// - Parameter id: The ID of the meal to delete
    public func delete(byId id: String) {
        guard let context = self.context else { return }
        
        let fetchDescriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate<OfflineMeal> { meal in
                meal.idMeal == id
            }
        )
        
        do {
            let meals = try context.fetch(fetchDescriptor)
            for meal in meals {
                context.delete(meal)
            }
            try context.save()
        } catch {
            debugPrint("Error deleting meal with id \(id): \(error)")
        }
    }
    
    /// Fetches all OfflineMeal entities from the database
    /// - Returns: Array of OfflineMeal entities sorted by date saved
    public func fetch() -> [OfflineMeal] {
        guard let context = self.context else { return [] }
        
        let fetchDescriptor = FetchDescriptor<OfflineMeal>(
            sortBy: [SortDescriptor(\.dateSaved, order: .reverse)]
        )
        
        do {
            let meals = try context.fetch(fetchDescriptor)
            return meals
        } catch {
            debugPrint("Error fetching meals: \(error)")
            return []
        }
    }
    
    /// Fetches an OfflineMeal entity by its ID
    /// - Parameter id: The ID of the meal to fetch
    /// - Returns: The OfflineMeal entity if found, nil otherwise
    public func fetch(byId id: String) -> OfflineMeal? {
        guard let context = self.context else { return nil }
        
        let fetchDescriptor = FetchDescriptor<OfflineMeal>(
            predicate: #Predicate<OfflineMeal> { meal in
                meal.idMeal == id
            }
        )
        
        do {
            let meals = try context.fetch(fetchDescriptor)
            return meals.first
        } catch {
            debugPrint("Error fetching meal with id \(id): \(error)")
            return nil
        }
    }
    
    /// Checks if a meal exists in the database
    /// - Parameter id: The ID of the meal to check
    /// - Returns: True if the meal exists, false otherwise
    public func exists(id: String) -> Bool {
        return fetch(byId: id) != nil
    }
    
    /// Gets the count of all OfflineMeal entities
    /// - Returns: The total count of meals
    public func count() -> Int {
        guard let context = self.context else { return 0 }
        
        let fetchDescriptor = FetchDescriptor<OfflineMeal>()
        
        do {
            let meals = try context.fetch(fetchDescriptor)
            return meals.count
        } catch {
            debugPrint("Error counting meals: \(error)")
            return 0
        }
    }
    
    /// Updates an existing OfflineMeal entity
    /// - Parameter entity: The OfflineMeal entity to update
    public func update(_ entity: OfflineMeal) {
        guard let context = self.context else { return }
        
        // The entity should already be tracked by the context
        // Just save the changes
        try? context.save()
    }
    
    /// Saves any pending changes to the database
    public func save() {
        guard let context = self.context else { return }
        
        if context.hasChanges {
            try? context.save()
        }
    }
}