//
//  AccessibilityHelpers.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit

// MARK: - Accessibility Extensions

extension View {
    
    /// Applies theme-aware accessibility configurations
    /// - Parameters:
    ///   - label: Accessibility label
    ///   - hint: Accessibility hint
    ///   - traits: Accessibility traits
    /// - Returns: View with enhanced accessibility
    func themeAccessibility(
        label: String? = nil,
        hint: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        self
            .accessibilityLabel(label ?? "")
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }
    
    /// Adds loading state accessibility
    /// - Parameter isLoading: Whether the view is in loading state
    /// - Returns: View with loading accessibility
    func loadingAccessibility(isLoading: Bool) -> some View {
        self
            .accessibilityLabel(isLoading ? "Loading" : "")
            .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
            .accessibilityRemoveTraits(isLoading ? .isButton : [])
    }
    
    /// Adds error state accessibility
    /// - Parameters:
    ///   - hasError: Whether the view has an error
    ///   - errorMessage: The error message
    /// - Returns: View with error accessibility
    func errorAccessibility(hasError: Bool, errorMessage: String? = nil) -> some View {
        self
            .accessibilityLabel(hasError ? "Error: \(errorMessage ?? "Something went wrong")" : "")
            .accessibilityAddTraits(hasError ? .isStaticText : [])
    }
}

// MARK: - Accessibility Rotors

struct MealAccessibilityRotor: AccessibilityRotorContent {
    let meals: [Meal]

    var body: some AccessibilityRotorContent {
        ForEach(meals) { meal in
            AccessibilityRotorEntry(meal.strMeal, id: meal.id)
        }
    }
}

struct IngredientAccessibilityRotor: AccessibilityRotorContent {
    let ingredients: [Ingredient]
    
    var body: some AccessibilityRotorContent {
        ForEach(ingredients) { ingredient in
            AccessibilityRotorEntry(
                "\(ingredient.name): \(ingredient.measure)",
                id: ingredient.id
            )
        }
    }
}

// MARK: - Accessibility Announcements

struct AccessibilityAnnouncement {
    static func dataLoaded(count: Int, type: String) {
        let message = "Loaded \(count) \(type)\(count == 1 ? "" : "s")"
        AccessibilityNotification.Announcement(message).post()
    }
    
    static func errorOccurred(_ message: String) {
        let errorMessage = "Error: \(message)"
        AccessibilityNotification.Announcement(errorMessage).post()
    }
    
    static func navigationOccurred(to destination: String) {
        let message = "Navigated to \(destination)"
        AccessibilityNotification.Announcement(message).post()
    }
}

// MARK: - Dynamic Type Support

extension Font {
    /// Creates a font that scales with Dynamic Type preferences
    /// - Parameters:
    ///   - style: The text style
    ///   - design: The font design
    ///   - weight: The font weight
    /// - Returns: A font that scales with accessibility settings
    static func accessibleFont(
        _ style: Font.TextStyle,
        design: Font.Design = .default,
        weight: Font.Weight = .regular
    ) -> Font {
        return Font.system(style, design: design, weight: weight)
    }
}

// MARK: - Voice Over Support

struct VoiceOverHelpers {
    
    /// Provides contextual information for meals cards
    /// - Parameter meal: The meal object
    /// - Returns: Comprehensive accessibility label
    static func mealCardLabel(for meal: Meal) -> String {
        return "\(meal.strMeal), meal recipe. Double tap to view detailed recipe and cooking instructions."
    }
    
    /// Provides contextual information for ingredient cards
    /// - Parameter ingredient: The ingredient object
    /// - Returns: Comprehensive accessibility label
    static func ingredientLabel(for ingredient: Ingredient) -> String {
        return "Ingredient: \(ingredient.name), amount: \(ingredient.measure)"
    }
    
    /// Provides navigation context
    /// - Parameters:
    ///   - currentView: Current view name
    ///   - totalItems: Total number of items
    ///   - currentIndex: Current item index (optional)
    /// - Returns: Navigation context string
    static func navigationContext(
        currentView: String,
        totalItems: Int? = nil,
        currentIndex: Int? = nil
    ) -> String {
        var context = "Currently in \(currentView)"
        
        if let total = totalItems {
            context += ", \(total) items available"
            
            if let index = currentIndex {
                context += ", currently at item \(index + 1) of \(total)"
            }
        }
        
        return context
    }
}

// MARK: - Accessibility Constants

enum AccessibilityConstants {
    static let minimumTapAreaSize: CGFloat = 44
    static let minimumTextContrast: Double = 4.5
    static let preferredAnimationDuration: Double = 0.3
    
    enum Labels {
        static let loading = "Loading content"
        static let retry = "Retry loading content"
        static let refresh = "Pull to refresh content"
        static let back = "Go back"
        static let close = "Close"
        static let favorite = "Add to favorites"
        static let unfavorite = "Remove from favorites"
    }
    
    enum Hints {
        static let mealCard = "Double tap to view detailed recipe"
        static let retryButton = "Tap to try loading the content again"
        static let refreshControl = "Pull down to refresh the list"
        static let navigationBack = "Returns to the previous screen"
    }
}

// MARK: - Accessibility Testing Helpers

#if DEBUG
struct AccessibilityTestHelpers {
    
    /// Validates that a view meets accessibility requirements
    /// - Parameter view: The view to validate
    /// - Returns: Array of accessibility issues found
    static func validateAccessibility<V: View>(for view: V) -> [String] {
        let issues: [String] = []
        
        // This would be expanded with actual validation logic
        // For now, it's a placeholder for future accessibility testing
        
        return issues
    }
    
    /// Simulates VoiceOver reading order
    /// - Parameter view: The view to analyze
    /// - Returns: Array of strings representing reading order
    static func simulateVoiceOverReading<V: View>(for view: V) -> [String] {
        // Placeholder for VoiceOver simulation
        // Would be implemented with actual view hierarchy analysis
        return []
    }
}
#endif

// MARK: - Preview Helpers

#Preview("Accessibility Demo") {
    VStack(spacing: Theme.Spacing.large.value) {
        Text("Accessibility Demo")
            .themeHeadline()
            .themeAccessibility(
                label: "Accessibility demonstration title",
                hint: "This shows how accessibility features work",
                traits: [.isHeader]
            )
        
        Button("Sample Button") {
            // Action
        }
        .themeAccessibility(
            label: "Sample action button",
            hint: AccessibilityConstants.Hints.retryButton,
            traits: [.isButton]
        )
        
        Text("Loading...")
            .themeBody()
            .loadingAccessibility(isLoading: true)
        
        Text("Error occurred")
            .themeBody()
            .errorAccessibility(hasError: true, errorMessage: "Network connection failed")
    }
    .themePadding(.all, .large)
    .background(Color.backgroundPrimary)
}
