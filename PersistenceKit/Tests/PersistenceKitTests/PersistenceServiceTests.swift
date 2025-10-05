//
//  PersistenceServiceTests.swift
//  PersistenceKitTests
//
//  Created by Ali FAKIH on 10/5/25.
//

import XCTest
@testable import PersistenceKit

final class PersistenceServiceTests: XCTestCase {
    
    var persistenceService: PersistenceService!
    
    override func setUp() async throws {
        // Create an in-memory persistence service for testing
        persistenceService = try PersistenceSetup.createInMemoryPersistenceService()
    }
    
    override func tearDown() async throws {
        persistenceService = nil
    }
    
    func testToggleFavorite() async throws {
        let mealID = "test_meal_123"
        
        // Initially should not be favorite
        let initialFavorite = try await persistenceService.isFavorite(mealID: mealID)
        XCTAssertFalse(initialFavorite)
        
        // Toggle to make it favorite
        try await persistenceService.toggleFavorite(mealID: mealID)
        let afterToggle = try await persistenceService.isFavorite(mealID: mealID)
        XCTAssertTrue(afterToggle)
        
        // Toggle again to remove from favorites
        try await persistenceService.toggleFavorite(mealID: mealID)
        let afterSecondToggle = try await persistenceService.isFavorite(mealID: mealID)
        XCTAssertFalse(afterSecondToggle)
    }
    
    func testAddAndRemoveFavorites() async throws {
        let mealID = "test_meal_456"
        
        // Add to favorites
        try await persistenceService.addToFavorites(mealID: mealID)
        let isFavorite = try await persistenceService.isFavorite(mealID: mealID)
        XCTAssertTrue(isFavorite)
        
        // Remove from favorites
        try await persistenceService.removeFromFavorites(mealID: mealID)
        let isNoLongerFavorite = try await persistenceService.isFavorite(mealID: mealID)
        XCTAssertFalse(isNoLongerFavorite)
    }
    
    func testFetchFavorites() async throws {
        let mealIDs = ["meal_1", "meal_2", "meal_3"]
        
        // Add multiple favorites
        for mealID in mealIDs {
            try await persistenceService.addToFavorites(mealID: mealID)
        }
        
        // Fetch all favorites
        let favorites = try await persistenceService.fetchFavorites()
        XCTAssertEqual(favorites.count, mealIDs.count)
        
        // Verify all meal IDs are present
        let favoriteIDs = favorites.map { $0.idMeal }
        for mealID in mealIDs {
            XCTAssertTrue(favoriteIDs.contains(mealID))
        }
    }
    
    func testGetFavoritesCount() async throws {
        // Initially should be 0
        let initialCount = try await persistenceService.getFavoritesCount()
        XCTAssertEqual(initialCount, 0)
        
        // Add some favorites
        try await persistenceService.addToFavorites(mealID: "meal_1")
        try await persistenceService.addToFavorites(mealID: "meal_2")
        
        let countAfterAdding = try await persistenceService.getFavoritesCount()
        XCTAssertEqual(countAfterAdding, 2)
    }
    
    func testClearAllFavorites() async throws {
        // Add some favorites
        try await persistenceService.addToFavorites(mealID: "meal_1")
        try await persistenceService.addToFavorites(mealID: "meal_2")
        
        // Verify they exist
        let countBeforeClear = try await persistenceService.getFavoritesCount()
        XCTAssertEqual(countBeforeClear, 2)
        
        // Clear all
        try await persistenceService.clearAllFavorites()
        
        // Verify they're gone
        let countAfterClear = try await persistenceService.getFavoritesCount()
        XCTAssertEqual(countAfterClear, 0)
    }
    
    func testUniqueConstraint() async throws {
        let mealID = "unique_meal"
        
        // Add the same meal ID multiple times
        try await persistenceService.addToFavorites(mealID: mealID)
        try await persistenceService.addToFavorites(mealID: mealID)
        try await persistenceService.addToFavorites(mealID: mealID)
        
        // Should only have one entry due to unique constraint
        let count = try await persistenceService.getFavoritesCount()
        XCTAssertEqual(count, 1)
        
        let favorites = try await persistenceService.fetchFavorites()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.idMeal, mealID)
    }
}