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
    static let mealsLoadingMore = NSLocalizedString("meals.loading_more", comment: "Loading more meals indicator")
    static let mealsEmptySearchTitle = NSLocalizedString("meals.empty_search.title", comment: "Empty search results title")
    static let mealsEmptySearchDescription = NSLocalizedString("meals.empty_search.description", comment: "Empty search results description")
    static let mealsEmptySearchSuggestion = NSLocalizedString("meals.empty_search.suggestion", comment: "Empty search results suggestion")
    
    static func mealsEmptySearchQuery(query: String) -> String {
        String(format: NSLocalizedString("meals.empty_search.query", comment: "No results for search query"), query)
    }
    
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
    
    // MARK: - Meal List Specific Error Messages
    static let errorMealsNoInternet = NSLocalizedString("error.meals.no_internet", comment: "No internet connection error for meals")
    static let errorMealsTimeout = NSLocalizedString("error.meals.timeout", comment: "Request timeout error for meals")
    static let errorMealsCancelled = NSLocalizedString("error.meals.cancelled", comment: "Request cancelled error for meals")
    static let errorMealsCannotReachServer = NSLocalizedString("error.meals.cannot_reach_server", comment: "Cannot reach server error for meals")
    static let errorMealsNetworkError = NSLocalizedString("error.meals.network_error", comment: "Network error for meals")
    static let errorMealsDecodingError = NSLocalizedString("error.meals.decoding_error", comment: "Decoding error for meals")
    static let errorMealsNoMealsFound = NSLocalizedString("error.meals.no_meals_found", comment: "No meals found error")
    static let errorMealsUnexpectedError = NSLocalizedString("error.meals.unexpected_error", comment: "Unexpected error for meals")
    
    static func errorMealsServerError(statusCode: Int) -> String {
        String(format: NSLocalizedString("error.meals.server_error", comment: "Server error for meals with status code"), statusCode)
    }
    
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
    
    // MARK: - Enhanced Accessibility
    static let accessibilityMealCard = NSLocalizedString("accessibility.meal_card", comment: "Meal card accessibility label")
    static let accessibilityMealCardHint = NSLocalizedString("accessibility.meal_card_hint", comment: "Meal card accessibility hint")
    static let accessibilityMealImage = NSLocalizedString("accessibility.meal_image", comment: "Meal image accessibility label")
    static let accessibilitySearchBar = NSLocalizedString("accessibility.search_bar", comment: "Search bar accessibility label")
    static let accessibilitySearchBarHint = NSLocalizedString("accessibility.search_bar_hint", comment: "Search bar accessibility hint")
    static let accessibilityFavoriteButton = NSLocalizedString("accessibility.favorite_button", comment: "Favorite button accessibility label")
    static let accessibilityFavoriteButtonAdd = NSLocalizedString("accessibility.favorite_button_add", comment: "Add to favorites accessibility label")
    static let accessibilityFavoriteButtonRemove = NSLocalizedString("accessibility.favorite_button_remove", comment: "Remove from favorites accessibility label")
    static let accessibilityFavoriteButtonHint = NSLocalizedString("accessibility.favorite_button_hint", comment: "Favorite button accessibility hint")
    static let accessibilityIngredientCard = NSLocalizedString("accessibility.ingredient_card", comment: "Ingredient card accessibility label")
    static let accessibilityIngredientCardHint = NSLocalizedString("accessibility.ingredient_card_hint", comment: "Ingredient card accessibility hint")
    static let accessibilityInstructionsSection = NSLocalizedString("accessibility.instructions_section", comment: "Instructions section accessibility label")
    static let accessibilityInstructionsSectionHint = NSLocalizedString("accessibility.instructions_section_hint", comment: "Instructions section accessibility hint")
    static let accessibilityIngredientsSection = NSLocalizedString("accessibility.ingredients_section", comment: "Ingredients section accessibility label")
    static let accessibilityIngredientsSectionHint = NSLocalizedString("accessibility.ingredients_section_hint", comment: "Ingredients section accessibility hint")
    static let accessibilityMealHeader = NSLocalizedString("accessibility.meal_header", comment: "Meal header accessibility label")
    static let accessibilityMealHeaderHint = NSLocalizedString("accessibility.meal_header_hint", comment: "Meal header accessibility hint")
    static let accessibilityPaginationTrigger = NSLocalizedString("accessibility.pagination_trigger", comment: "Pagination trigger accessibility label")
    static let accessibilityPaginationHint = NSLocalizedString("accessibility.pagination_hint", comment: "Pagination accessibility hint")
    static let accessibilityEmptySearch = NSLocalizedString("accessibility.empty_search", comment: "Empty search accessibility label")
    static let accessibilityEmptySearchHint = NSLocalizedString("accessibility.empty_search_hint", comment: "Empty search accessibility hint")
    static let accessibilityShimmerLoading = NSLocalizedString("accessibility.shimmer_loading", comment: "Shimmer loading accessibility label")
    static let accessibilityShimmerHint = NSLocalizedString("accessibility.shimmer_hint", comment: "Shimmer accessibility hint")
    static let accessibilityFavoritesEmpty = NSLocalizedString("accessibility.favorites_empty", comment: "Empty favorites accessibility label")
    static let accessibilityFavoritesEmptyHint = NSLocalizedString("accessibility.favorites_empty_hint", comment: "Empty favorites accessibility hint")
    static let accessibilityRemoveFavorite = NSLocalizedString("accessibility.remove_favorite", comment: "Remove favorite accessibility label")
    static let accessibilityRemoveFavoriteHint = NSLocalizedString("accessibility.remove_favorite_hint", comment: "Remove favorite accessibility hint")
    static let accessibilityNavigationBack = NSLocalizedString("accessibility.navigation_back", comment: "Navigation back accessibility label")
    static let accessibilityNavigationBackHint = NSLocalizedString("accessibility.navigation_back_hint", comment: "Navigation back accessibility hint")
    
    static func accessibilityRecipeCount(_ count: Int) -> String {
        String(format: NSLocalizedString("accessibility.recipe_count", comment: "Recipe count accessibility"), count)
    }
    
    static func accessibilityIngredientCount(_ count: Int) -> String {
        String(format: NSLocalizedString("accessibility.ingredient_count", comment: "Ingredient count accessibility"), count)
    }
    
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
    
    // MARK: - Additional UI Strings
    static let uiRecipe = NSLocalizedString("ui.recipe", comment: "Recipe label")
    static let uiLoadingImage = NSLocalizedString("ui.loading_image", comment: "Loading image text")
    static let uiRecipeDetails = NSLocalizedString("ui.recipe_details", comment: "Recipe details label")
    static let uiItems = NSLocalizedString("ui.items", comment: "Items count label")
    static let uiCategoriesGrid = NSLocalizedString("ui.categories_grid", comment: "Categories grid label")
    static let uiFavoriteRecipe = NSLocalizedString("ui.favorite_recipe", comment: "Favorite recipe label")
    static let uiDoubleTapRecipeDetails = NSLocalizedString("ui.double_tap_recipe_details", comment: "Double tap for recipe details hint")
    static let uiExploreMeals = NSLocalizedString("ui.explore_meals", comment: "Explore meals button")
    static let uiUnableToLoadFavorites = NSLocalizedString("ui.unable_to_load_favorites", comment: "Unable to load favorites error")
    static let uiErrorLoadingFavorites = NSLocalizedString("ui.error_loading_favorites", comment: "Error loading favorites message")
    static let uiRetry = NSLocalizedString("ui.retry", comment: "Retry button")
    static let uiLoadingFavorites = NSLocalizedString("ui.loading_favorites", comment: "Loading favorites message")
    
    static func uiShowingRecipes(_ count: Int) -> String {
        String(format: NSLocalizedString("ui.showing_recipes", comment: "Showing recipes count"), count)
    }
    
    static func uiSavedWithIngredients(date: String, ingredientCount: Int) -> String {
        String(format: NSLocalizedString("ui.saved_with_ingredients", comment: "Saved date with ingredient count"), date, ingredientCount)
    }
    
    static func uiNoResultsFor(query: String) -> String {
        String(format: NSLocalizedString("ui.no_results_for", comment: "No results for query"), query)
    }
}