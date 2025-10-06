//
//  LocalizedStrings.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/5/25.
//

import Foundation

/// Centralized access to localized strings
enum LocalizedStrings {
    
    // MARK: - Navigation & General
    static let appTitle = NSLocalizedString("app.title", comment: "App title")
    static let navigationBack = NSLocalizedString("navigation.back", comment: "Back button")
    static let navigationDone = NSLocalizedString("navigation.done", comment: "Done button")
    static let navigationCancel = NSLocalizedString("navigation.cancel", comment: "Cancel button")
    static let navigationRetry = NSLocalizedString("navigation.retry", comment: "Retry button")
    static let navigationClose = NSLocalizedString("navigation.close", comment: "Close button")
    
    // MARK: - Category List
    static let categoriesTitle = NSLocalizedString("categories.title", comment: "Categories screen title")
    static let categoriesNavigationTitle = NSLocalizedString("categories.navigation_title", comment: "Categories navigation title")
    static let categoriesLoading = NSLocalizedString("categories.loading", comment: "Loading categories message")
    static let categoriesLoadingDescription = NSLocalizedString("categories.loading_description", comment: "Loading categories description")
    static let categoriesLoadMore = NSLocalizedString("categories.load_more", comment: "Load more button")
    static let categoriesLoadingMore = NSLocalizedString("categories.loading_more", comment: "Loading more categories")
    static let categoriesEmptyTitle = NSLocalizedString("categories.empty.title", comment: "Empty categories title")
    static let categoriesEmptyDescription = NSLocalizedString("categories.empty.description", comment: "Empty categories description")
    static let categoriesErrorTitle = NSLocalizedString("categories.error.title", comment: "Categories error title")
    static let categoriesErrorDescription = NSLocalizedString("categories.error.description", comment: "Categories error description")
    static let categoriesRetryButton = NSLocalizedString("categories.retry_button", comment: "Retry button text")
    
    // MARK: - Meal List
    static let mealsSearchPlaceholder = NSLocalizedString("meals.search_placeholder", comment: "Meals search placeholder")
    static let mealsErrorTitle = NSLocalizedString("meals.error.title", comment: "Meals error title")
    static let mealsErrorDefault = NSLocalizedString("meals.error.default", comment: "Default meals error message")
    static let mealsTryAgain = NSLocalizedString("meals.try_again", comment: "Try again button")
    static let mealsTapToView = NSLocalizedString("meals.tap_to_view", comment: "Tap to view recipe hint")
    
    static func mealsLoading(category: String) -> String {
        String(format: NSLocalizedString("meals.loading", comment: "Loading meals for category"), category)
    }
    
    static let mealsLoadingDescription = NSLocalizedString("meals.loading_description", comment: "Loading meals description")
    
    // MARK: - Meal Detail
    static let mealDetailIngredients = NSLocalizedString("meal_detail.ingredients", comment: "Ingredients section title")
    static let mealDetailInstructions = NSLocalizedString("meal_detail.instructions", comment: "Instructions section title")
    static let mealDetailFavoriteAdd = NSLocalizedString("meal_detail.favorite.add", comment: "Add to favorites")
    static let mealDetailFavoriteRemove = NSLocalizedString("meal_detail.favorite.remove", comment: "Remove from favorites")
    static let mealDetailFavoriteAdded = NSLocalizedString("meal_detail.favorite.added", comment: "Added to favorites")
    static let mealDetailFavoriteRemoved = NSLocalizedString("meal_detail.favorite.removed", comment: "Removed from favorites")
    static let mealDetailLoading = NSLocalizedString("meal_detail.loading", comment: "Loading meal detail")
    static let mealDetailErrorTitle = NSLocalizedString("meal_detail.error.title", comment: "Meal detail error title")
    static let mealDetailErrorDescription = NSLocalizedString("meal_detail.error.description", comment: "Meal detail error description")
    
    // MARK: - Favorites
    static let favoritesTitle = NSLocalizedString("favorites.title", comment: "Favorites screen title")
    static let favoritesNavigationTitle = NSLocalizedString("favorites.navigation_title", comment: "Favorites navigation title")
    static let favoritesCountZero = NSLocalizedString("favorites.count_zero", comment: "No favorites message")
    static let favoritesEmptyTitle = NSLocalizedString("favorites.empty.title", comment: "Empty favorites title")
    static let favoritesEmptyDescription = NSLocalizedString("favorites.empty.description", comment: "Empty favorites description")
    static let favoritesEmptyBrowse = NSLocalizedString("favorites.empty.browse", comment: "Browse recipes button")
    static let favoritesCardTitle = NSLocalizedString("favorites.card_title", comment: "Favorites card title")
    static let favoritesCardDescription = NSLocalizedString("favorites.card_description", comment: "Favorites card description")
    
    static func favoritesCount(_ count: Int) -> String {
        if count == 1 {
            return NSLocalizedString("favorites.count_one", comment: "One favorite meal")
        } else {
            return String(format: NSLocalizedString("favorites.count_many", comment: "Multiple favorite meals"), count)
        }
    }
    
    // MARK: - Loading States
    static let loadingDefault = NSLocalizedString("loading.default", comment: "Default loading message")
    static let loadingPleaseWait = NSLocalizedString("loading.please_wait", comment: "Please wait message")
    static let loadingCategories = NSLocalizedString("loading.categories", comment: "Loading categories")
    static let loadingMeals = NSLocalizedString("loading.meals", comment: "Loading meals")
    static let loadingRecipe = NSLocalizedString("loading.recipe", comment: "Loading recipe")
    
    // MARK: - Error Messages
    static let errorNetworkTitle = NSLocalizedString("error.network.title", comment: "Network error title")
    static let errorNetworkDescription = NSLocalizedString("error.network.description", comment: "Network error description")
    static let errorServerTitle = NSLocalizedString("error.server.title", comment: "Server error title")
    static let errorServerDescription = NSLocalizedString("error.server.description", comment: "Server error description")
    static let errorTimeoutTitle = NSLocalizedString("error.timeout.title", comment: "Timeout error title")
    static let errorTimeoutDescription = NSLocalizedString("error.timeout.description", comment: "Timeout error description")
    static let errorUnknownTitle = NSLocalizedString("error.unknown.title", comment: "Unknown error title")
    static let errorUnknownDescription = NSLocalizedString("error.unknown.description", comment: "Unknown error description")
    
    // MARK: - Accessibility
    static let accessibilityMealList = NSLocalizedString("accessibility.meal_list", comment: "Meal list accessibility label")
    static let accessibilityMealListHint = NSLocalizedString("accessibility.meal_list_hint", comment: "Meal list accessibility hint")
    static let accessibilityFavorited = NSLocalizedString("accessibility.favorited", comment: "Favorited accessibility label")
    static let accessibilityErrorLoading = NSLocalizedString("accessibility.error_loading", comment: "Error loading accessibility")
    static let accessibilityRetryHint = NSLocalizedString("accessibility.retry_hint", comment: "Retry accessibility hint")
    static let accessibilityCategoryCard = NSLocalizedString("accessibility.category_card", comment: "Category card accessibility label")
    static let accessibilityCategoryCardHint = NSLocalizedString("accessibility.category_card_hint", comment: "Category card accessibility hint")
    static let accessibilityFavoritesCard = NSLocalizedString("accessibility.favorites_card", comment: "Favorites card accessibility label")
    static let accessibilityFavoritesCardHint = NSLocalizedString("accessibility.favorites_card_hint", comment: "Favorites card accessibility hint")
    static let accessibilityCategoryImage = NSLocalizedString("accessibility.category_image", comment: "Category image accessibility label")
    static let accessibilityLoadingView = NSLocalizedString("accessibility.loading_view", comment: "Loading view accessibility label")
    static let accessibilityEmptyView = NSLocalizedString("accessibility.empty_view", comment: "Empty view accessibility label")
    static let accessibilityErrorView = NSLocalizedString("accessibility.error_view", comment: "Error view accessibility label")
    
    static func accessibilityLoadingMeals(category: String) -> String {
        String(format: NSLocalizedString("accessibility.loading_meals", comment: "Loading meals accessibility"), category)
    }
    
    static let accessibilityLoadingHint = NSLocalizedString("accessibility.loading_hint", comment: "Loading accessibility hint")
    
    // MARK: - Categories
    static let categoryDessert = NSLocalizedString("category.dessert", comment: "Dessert category")
    static let categoryBreakfast = NSLocalizedString("category.breakfast", comment: "Breakfast category")
    static let categoryChicken = NSLocalizedString("category.chicken", comment: "Chicken category")
    static let categoryPasta = NSLocalizedString("category.pasta", comment: "Pasta category")
    static let categorySeafood = NSLocalizedString("category.seafood", comment: "Seafood category")
    
    // MARK: - Category Descriptions
    static let categoryDessertDescription = NSLocalizedString("category.dessert.description", comment: "Dessert category description")
    static let categoryBreakfastDescription = NSLocalizedString("category.breakfast.description", comment: "Breakfast category description")
    static let categoryChickenDescription = NSLocalizedString("category.chicken.description", comment: "Chicken category description")
    static let categoryPastaDescription = NSLocalizedString("category.pasta.description", comment: "Pasta category description")
    static let categorySeafoodDescription = NSLocalizedString("category.seafood.description", comment: "Seafood category description")
}