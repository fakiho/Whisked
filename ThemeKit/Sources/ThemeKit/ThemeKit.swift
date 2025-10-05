//
//  ThemeKit.swift
//  ThemeKit
//
//  Created by ThemeKit on 10/5/25.
//

import SwiftUI

/// ThemeKit - A comprehensive design system for the WHISKED app
/// 
/// Provides consistent design tokens including:
/// - Color palette with automatic light/dark mode support
/// - Typography system with Dynamic Type support  
/// - Spacing system with standardized values
/// - Corner radius and layout dimensions
///
/// Usage:
/// ```swift
/// import ThemeKit
/// 
/// // Using colors
/// Text("Hello").foregroundColor(.textPrimary)
/// Rectangle().fill(.backgroundSecondary)
/// 
/// // Using typography
/// Text("Headline").font(.themeHeadline())
/// Text("Body text").themeBody()
/// 
/// // Using spacing
/// VStack(spacing: Theme.Spacing.medium) { ... }
/// .themePaddingLarge()
/// ```
public struct ThemeKit {
    
    /// Current version of ThemeKit
    public static let version = "1.0.0"
    
    /// Indicates if the theme system is available
    public static let isAvailable = true
    
    private init() {
        // Prevent instantiation - this is a namespace
    }
}

// MARK: - Public Exports

// Main theme components are available through their respective extensions:
// - Color extensions: Color.textPrimary, Color.backgroundSecondary, etc.
// - Font extensions: Font.themeHeadline(), Font.themeBody(), etc.  
// - Spacing values: Theme.Spacing.medium, Theme.CornerRadius.large, etc.