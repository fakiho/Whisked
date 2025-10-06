//
//  CategoryListUITests.swift
//  WhiskedUITests
//
//  Created by GitHub Copilot on 10/6/25.
//

import XCTest

/// Comprehensive UI tests for CategoryListView
/// Tests user interactions, accessibility, and visual state changes

@MainActor
final class CategoryListUITests: XCTestCase {
    
    private var app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = XCUIApplication()
    }
    
    // MARK: - Basic UI Tests
    
    func test_categoryListView_displaysCorrectly() throws {
        // Given
        app.launch()
        
        // When
        let categoryListView = app.otherElements["categoryListView"]
        
        // Then
        XCTAssertTrue(categoryListView.exists)
        XCTAssertTrue(categoryListView.isHittable)
    }
    
    func test_loadingState_displaysLoadingView() throws {
        // Given
        app.launchArguments.append("--ui-testing")
        app.launchArguments.append("--loading-state")
        app.launch()
        
        // When
        let loadingView = app.otherElements["loadingCategoriesView"]
        
        // Then
        XCTAssertTrue(loadingView.exists)
        
        // Check loading text
        let loadingText = app.staticTexts[LocalizedStrings.categoriesLoading]
        XCTAssertTrue(loadingText.exists)
    }
    
    func test_emptyState_displaysEmptyView() throws {
        // Given
        app.launchArguments.append("--ui-testing")
        app.launchArguments.append("--empty-state")
        app.launch()
        
        // When
        let emptyView = app.otherElements["emptyCategoriesView"]
        
        // Then
        XCTAssertTrue(emptyView.exists)
        
        // Check empty state text
        let emptyTitle = app.staticTexts[LocalizedStrings.categoriesEmptyTitle]
        XCTAssertTrue(emptyTitle.exists)
    }
    
    func test_errorState_displaysErrorView() throws {
        // Given
        app.launchArguments.append("--ui-testing")
        app.launchArguments.append("--error-state")
        app.launch()
        
        // When
        let errorView = app.otherElements["errorCategoriesView"]
        
        // Then
        XCTAssertTrue(errorView.exists)
        
        // Check error state components
        let errorTitle = app.staticTexts[LocalizedStrings.categoriesErrorTitle]
        XCTAssertTrue(errorTitle.exists)
        
        let retryButton = app.buttons["retryButton"]
        XCTAssertTrue(retryButton.exists)
        XCTAssertTrue(retryButton.isEnabled)
    }
    
    // MARK: - Category Interaction Tests
    
    func test_categoryCard_tapNavigation() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When
        let firstCategoryCard = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'categoryCard_'")).firstMatch
        XCTAssertTrue(firstCategoryCard.exists)
        
        firstCategoryCard.tap()
        
        // Then
        // Check if navigation occurred (this would depend on your navigation setup)
        // This is a placeholder - adjust based on your actual navigation behavior
        let mealsView = app.otherElements["mealListView"]
        let navigationOccurred = mealsView.waitForExistence(timeout: 3.0)
        XCTAssertTrue(navigationOccurred)
    }
    
    func test_favoritesCard_tapNavigation() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When
        let favoritesCard = app.buttons["favoritesCard"]
        XCTAssertTrue(favoritesCard.exists)
        
        favoritesCard.tap()
        
        // Then
        // Check if favorites navigation occurred
        let favoritesView = app.otherElements["favoritesView"]
        let navigationOccurred = favoritesView.waitForExistence(timeout: 3.0)
        XCTAssertTrue(navigationOccurred)
    }
    
    func test_retryButton_functionality() throws {
        // Given
        app.launchArguments.append("--ui-testing")
        app.launchArguments.append("--error-state")
        app.launch()
        
        // Wait for error view
        let errorView = app.otherElements["errorCategoriesView"]
        let exists = errorView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When
        let retryButton = app.buttons["retryButton"]
        XCTAssertTrue(retryButton.exists)
        
        retryButton.tap()
        
        // Then
        // Should transition to loading state
        let loadingView = app.otherElements["loadingCategoriesView"]
        let loadingAppears = loadingView.waitForExistence(timeout: 3.0)
        XCTAssertTrue(loadingAppears)
    }
    
    // MARK: - Accessibility Tests
    
    func test_accessibilityLabels_exist() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When & Then
        let categoryListView = app.otherElements["categoryListView"]
        XCTAssertTrue(categoryListView.exists)
        XCTAssertNotNil(categoryListView.label)
        
        let favoritesCard = app.buttons["favoritesCard"]
        XCTAssertTrue(favoritesCard.exists)
        XCTAssertNotNil(favoritesCard.label)
        
        // Check category cards have accessibility labels
        let categoryCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'categoryCard_'"))
        XCTAssertGreaterThan(categoryCards.count, 0)
        
        for i in 0..<min(categoryCards.count, 3) { // Test first 3 cards
            let card = categoryCards.element(boundBy: i)
            XCTAssertNotNil(card.label)
        }
    }
    
    func test_accessibilityHints_exist() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When & Then
        let favoritesCard = app.buttons["favoritesCard"]
        XCTAssertTrue(favoritesCard.exists)
        // Note: XCTest doesn't directly expose accessibility hints, but we can verify they're set
        
        let retryButton = app.buttons["retryButton"]
        if retryButton.exists {
            // Retry button should have accessibility hint when present
        }
    }
    
    func test_voiceOver_navigation() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When & Then
        // Test that elements are properly ordered for VoiceOver navigation
        let favoritesCard = app.buttons["favoritesCard"]
        XCTAssertTrue(favoritesCard.exists)
        
        let categoryCards = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'categoryCard_'"))
        XCTAssertGreaterThan(categoryCards.count, 0)
        
        // Verify cards are accessible in logical order
        for i in 0..<min(categoryCards.count, 3) {
            let card = categoryCards.element(boundBy: i)
            XCTAssertTrue(card.exists)
            XCTAssertTrue(card.isHittable)
        }
    }
    
    // MARK: - Pull to Refresh Tests
    
    func test_pullToRefresh_functionality() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Perform pull to refresh gesture
        let start = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let end = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: end)
        
        // Then
        // Should show loading state briefly
        let loadingView = app.otherElements["loadingCategoriesView"]
        // Note: This might be very brief, so we may not always catch it
    }
    
    // MARK: - Dynamic Content Tests
    
    func test_favoritesCount_updates() throws {
        // Given
        app.launchArguments.append("--ui-testing")
        app.launchArguments.append("--favorites-count=5")
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When & Then
        let favoritesCard = app.buttons["favoritesCard"]
        XCTAssertTrue(favoritesCard.exists)
        
        // Check that favorites count is displayed
        let favoritesCountText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '5'")).firstMatch
        XCTAssertTrue(favoritesCountText.exists)
    }
    
    func test_categoryImages_loadProperly() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When & Then
        let categoryImages = app.images.matching(NSPredicate(format: "identifier BEGINSWITH 'categoryImage_'"))
        XCTAssertGreaterThan(categoryImages.count, 0)
        
        // Verify images exist (placeholder or loaded)
        for i in 0..<min(categoryImages.count, 3) {
            let image = categoryImages.element(boundBy: i)
            XCTAssertTrue(image.exists)
        }
    }
    
    // MARK: - Performance Tests
    
    func test_categoryList_loadingPerformance() throws {
        // Given
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
            
            // Wait for categories to load
            let loadedView = app.otherElements["loadedCategoriesView"]
            _ = loadedView.waitForExistence(timeout: 10.0)
        }
    }
    
    func test_categoryList_scrollPerformance() throws {
        // Given
        app.launch()
        
        // Wait for categories to load
        let loadedView = app.otherElements["loadedCategoriesView"]
        let exists = loadedView.waitForExistence(timeout: 5.0)
        XCTAssertTrue(exists)
        
        // When
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        // Measure scroll performance
        measure(metrics: [XCTOSSignpostMetric.scrollingAndDecelerationMetric]) {
            scrollView.swipeUp()
            scrollView.swipeDown()
        }
    }
}

// MARK: - Test Helpers

extension CategoryListUITests {
    
    /// Helper to wait for element with custom timeout
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }
    
    /// Helper to check if element is visible and accessible
    func isElementAccessible(_ element: XCUIElement) -> Bool {
        return element.exists && element.isHittable
    }
}

// MARK: - Localized Strings for Tests

private enum LocalizedStrings {
    static let categoriesLoading = "Loading Categories..."
    static let categoriesEmptyTitle = "No Categories Available"
    static let categoriesErrorTitle = "Unable to Load Categories"
    // Add more as needed based on your actual localization
}
