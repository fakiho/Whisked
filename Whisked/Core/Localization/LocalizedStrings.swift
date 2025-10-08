//
//  LocalizedStrings.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/5/25.
//

import Foundation

/// Centralized access to localized strings
/// Now automatically uses the current language from LocalizableManager
enum LocalizedStrings {
    
    /// Internal helper method to get localized strings using our dynamic system
    private static func localized(_ key: String) -> String {
        return Bundle.localizedBundle().localizedString(forKey: key, value: nil, table: nil)
    }

    static var languageSwitchButton: String { localized("language.switch_button") }
    static var languageEnglish: String { localized("language.english") }
    static var languageFrench: String { localized("language.french") }
    
    // MARK: - Navigation & General
    static var appTitle: String { localized("app.title") }
    static var navigationBack: String { localized("navigation.back") }
    static var navigationDone: String { localized("navigation.done") }
    static var navigationCancel: String { localized("navigation.cancel") }
    static var navigationRetry: String { localized("navigation.retry") }
    static var navigationClose: String { localized("navigation.close") }
    
    // MARK: - Category List
    static var categoriesTitle: String { localized("categories.title") }
    static var categoriesNavigationTitle: String { localized("categories.navigation_title") }
    static var categoriesLoading: String { localized("categories.loading") }
    static var categoriesLoadingDescription: String { localized("categories.loading_description") }
    static var categoriesLoadMore: String { localized("categories.load_more") }
    static var categoriesLoadingMore: String { localized("categories.loading_more") }
    static var categoriesEmptyTitle: String { localized("categories.empty.title") }
    static var categoriesEmptyDescription: String { localized("categories.empty.description") }
    static var categoriesErrorTitle: String { localized("categories.error.title") }
    static var categoriesErrorDescription: String { localized("categories.error.description") }
    static var categoriesRetryButton: String { localized("categories.retry_button") }
    
    // MARK: - Meal List
    static var mealsSearchPlaceholder: String { localized("meals.search_placeholder") }
    static var mealsErrorTitle: String { localized("meals.error.title") }
    static var mealsErrorDefault: String { localized("meals.error.default") }
    static var mealsTryAgain: String { localized("meals.try_again") }
    static var mealsTapToView: String { localized("meals.tap_to_view") }
    static var mealsLoadingMore: String { localized("meals.loading_more") }
    static var mealsEmptySearchTitle: String { localized("meals.empty_search.title") }
    static var mealsEmptySearchDescription: String { localized("meals.empty_search.description") }
    static var mealsEmptySearchSuggestion: String { localized("meals.empty_search.suggestion") }
    
    static func mealsEmptySearchQuery(query: String) -> String {
        String(format: localized("meals.empty_search.query"), query)
    }
    
    static func mealsLoading(category: String) -> String {
        String(format: localized("meals.loading"), category)
    }
    
    static var mealsLoadingDescription: String { localized("meals.loading_description") }
    
    // MARK: - Meal Detail
    static var mealDetailIngredients: String { localized("meal_detail.ingredients") }
    static var mealDetailInstructions: String { localized("meal_detail.instructions") }
    static var mealDetailFavoriteAdd: String { localized("meal_detail.favorite.add") }
    static var mealDetailFavoriteRemove: String { localized("meal_detail.favorite.remove") }
    static var mealDetailFavoriteAdded: String { localized("meal_detail.favorite.added") }
    static var mealDetailFavoriteRemoved: String { localized("meal_detail.favorite.removed") }
    static var mealDetailLoading: String { localized("meal_detail.loading") }
    static var mealDetailErrorTitle: String { localized("meal_detail.error.title") }
    static var mealDetailErrorDescription: String { localized("meal_detail.error.description") }
    
    // MARK: - Favorites
    static var favoritesTitle: String { localized("favorites.title") }
    static var favoritesNavigationTitle: String { localized("favorites.navigation_title") }
    static var favoritesCountZero: String { localized("favorites.count_zero") }
    static var favoritesEmptyTitle: String { localized("favorites.empty.title") }
    static var favoritesEmptyDescription: String { localized("favorites.empty.description") }
    static var favoritesEmptyBrowse: String { localized("favorites.empty.browse") }
    static var favoritesCardTitle: String { localized("favorites.card_title") }
    static var favoritesCardDescription: String { localized("favorites.card_description") }
    
    static func favoritesCount(_ count: Int) -> String {
        if count == 1 {
            return localized("favorites.count_one")
        } else {
            return String(format: localized("favorites.count_many"), count)
        }
    }
    
    // MARK: - Loading States
    static var loadingDefault: String { localized("loading.default") }
    static var loadingPleaseWait: String { localized("loading.please_wait") }
    static var loadingCategories: String { localized("loading.categories") }
    static var loadingMeals: String { localized("loading.meals") }
    static var loadingRecipe: String { localized("loading.recipe") }
    
    // MARK: - Error Messages
    static var errorNetworkTitle: String { localized("error.network.title") }
    static var errorNetworkDescription: String { localized("error.network.description") }
    static var errorServerTitle: String { localized("error.server.title") }
    static var errorServerDescription: String { localized("error.server.description") }
    static var errorTimeoutTitle: String { localized("error.timeout.title") }
    static var errorTimeoutDescription: String { localized("error.timeout.description") }
    static var errorUnknownTitle: String { localized("error.unknown.title") }
    static var errorUnknownDescription: String { localized("error.unknown.description") }
    
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
    static var accessibilityMealList: String { localized("accessibility.meal_list") }
    static var accessibilityMealListHint: String { localized("accessibility.meal_list_hint") }
    static var accessibilityFavorited: String { localized("accessibility.favorited") }
    static var accessibilityErrorLoading: String { localized("accessibility.error_loading") }
    static var accessibilityRetryHint: String { localized("accessibility.retry_hint") }
    static var accessibilityCategoryCard: String { localized("accessibility.category_card") }
    static var accessibilityCategoryCardHint: String { localized("accessibility.category_card_hint") }
    static var accessibilityFavoritesCard: String { localized("accessibility.favorites_card") }
    static var accessibilityFavoritesCardHint: String { localized("accessibility.favorites_card_hint") }
    static var accessibilityCategoryImage: String { localized("accessibility.category_image") }
    static var accessibilityLoadingView: String { localized("accessibility.loading_view") }
    static var accessibilityEmptyView: String { localized("accessibility.empty_view") }
    static var accessibilityErrorView: String { localized("accessibility.error_view") }
    
    static func accessibilityLoadingMeals(category: String) -> String {
        String(format: localized("accessibility.loading_meals"), category)
    }
    
    static var accessibilityLoadingHint: String { localized("accessibility.loading_hint") }
    
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
        String(format: localized("accessibility.recipe_count"), count)
    }
    
    static func accessibilityIngredientCount(_ count: Int) -> String {
        String(format: localized("accessibility.ingredient_count"), count)
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
    static var uiCategoriesGrid: String { localized("ui.categories_grid") }
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
