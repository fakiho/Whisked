//
//  Theme+Spacing.swift
//  ThemeKit
//
//  Created by ThemeKit on 10/5/25.
//

import Foundation
import SwiftUI

// MARK: - Theme Namespace

public enum Theme {
    
    // MARK: - Spacing System
    
    /// Standard spacing values for consistent layout
    public enum Spacing: CGFloat, CaseIterable {
        
        /// Extra small spacing (4pt)
        /// Use for: tight padding, small element separation
        case extraSmall = 4
        
        /// Small spacing (8pt)
        /// Use for: compact layouts, minimal padding
        case small = 8
        
        /// Medium spacing (16pt)
        /// Use for: default padding, element separation
        case medium = 16
        
        /// Large spacing (24pt)
        /// Use for: section separation, generous padding
        case large = 24
        
        /// Extra large spacing (32pt)
        /// Use for: major section breaks, hero spacing
        case extraLarge = 32
        
        /// Huge spacing (48pt)
        /// Use for: maximum separation, page-level spacing
        case huge = 48
        
        /// The CGFloat value of the spacing
        public var value: CGFloat {
            return self.rawValue
        }
    }
    
    // MARK: - Corner Radius System
    
    /// Standard corner radius values for UI elements
    public enum CornerRadius {
        
        /// Small corner radius (4pt)
        /// Use for: buttons, small cards
        public static let small: CGFloat = 4
        
        /// Medium corner radius (8pt)
        /// Use for: cards, containers
        public static let medium: CGFloat = 8
        
        /// Large corner radius (12pt)
        /// Use for: prominent cards, modals
        public static let large: CGFloat = 12
        
        /// Extra large corner radius (16pt)
        /// Use for: hero elements, special containers
        public static let extraLarge: CGFloat = 16
        
        /// Circle radius for fully rounded elements
        public static let circle: CGFloat = 50 // Large enough for most elements
    }
    
    // MARK: - Icon Sizes
    
    /// Standard icon sizes for consistent iconography
    public enum IconSize {
        
        /// Small icon size (16x16pt)
        /// Use for: inline icons, compact layouts
        public static let small: CGFloat = 16
        
        /// Medium icon size (24x24pt)
        /// Use for: standard icons, toolbar items
        public static let medium: CGFloat = 24
        
        /// Large icon size (32x32pt)
        /// Use for: prominent icons, headers
        public static let large: CGFloat = 32
        
        /// Extra large icon size (48x48pt)
        /// Use for: hero icons, feature highlights
        public static let extraLarge: CGFloat = 48
    }
    
    // MARK: - Layout Dimensions
    
    /// Standard layout dimensions
    public enum Layout {
        
        /// Standard button height
        public static let buttonHeight: CGFloat = 44
        
        /// Compact button height
        public static let buttonHeightCompact: CGFloat = 36
        
        /// Standard input field height
        public static let inputHeight: CGFloat = 44
        
        /// Standard navigation bar height (system default)
        public static let navigationBarHeight: CGFloat = 44
        
        /// Standard tab bar height (system default)
        public static let tabBarHeight: CGFloat = 49
        
        /// Standard list row height
        public static let listRowHeight: CGFloat = 56
        
        /// Compact list row height
        public static let listRowHeightCompact: CGFloat = 44
        
        /// Card minimum height
        public static let cardMinHeight: CGFloat = 120
        
        /// Maximum content width for readability
        public static let maxContentWidth: CGFloat = 600
    }
}

// MARK: - SwiftUI Extensions

public extension EdgeInsets {
    
    /// Creates edge insets with theme spacing values
    /// - Parameter spacing: The spacing value to use for all edges
    /// - Returns: EdgeInsets with the specified spacing
    static func theme(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }
    
    /// Creates edge insets with different horizontal and vertical spacing
    /// - Parameters:
    ///   - horizontal: Spacing for leading and trailing edges
    ///   - vertical: Spacing for top and bottom edges
    /// - Returns: EdgeInsets with the specified spacing
    static func theme(horizontal: CGFloat, vertical: CGFloat) -> EdgeInsets {
        EdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    /// Common theme edge insets
    static let themeExtraSmall = EdgeInsets.theme(Theme.Spacing.extraSmall.value)
    static let themeSmall = EdgeInsets.theme(Theme.Spacing.small.value)
    static let themeMedium = EdgeInsets.theme(Theme.Spacing.medium.value)
    static let themeLarge = EdgeInsets.theme(Theme.Spacing.large.value)
    static let themeExtraLarge = EdgeInsets.theme(Theme.Spacing.extraLarge.value)
}

public extension View {
    
    /// Applies theme padding to all edges
    /// - Parameter spacing: The spacing value to use
    /// - Returns: View with theme padding applied
    func themePadding(_ spacing: CGFloat) -> some View {
        self.padding(spacing)
    }
    
    /// Applies theme padding using predefined spacing values
    /// - Parameter edge: The edge to apply padding to (optional)
    /// - Returns: View with theme padding applied
    func themePadding(_ edges: Edge.Set = .all, _ spacing: CGFloat) -> some View {
        self.padding(edges, spacing)
    }
    
    /// Applies theme padding using Theme.Spacing enum values
    /// - Parameters:
    ///   - edges: The edges to apply padding to
    ///   - spacing: The Theme.Spacing value to use
    /// - Returns: View with theme padding applied
    func themePadding(_ edges: Edge.Set = .all, _ spacing: Theme.Spacing) -> some View {
        self.padding(edges, spacing.value)
    }
    
    /// Convenience methods for common spacing values
    func themePaddingExtraSmall(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges, Theme.Spacing.extraSmall.value)
    }
    
    func themePaddingSmall(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges, Theme.Spacing.small.value)
    }
    
    func themePaddingMedium(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges, Theme.Spacing.medium.value)
    }
    
    func themePaddingLarge(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges, Theme.Spacing.large.value)
    }
    
    func themePaddingExtraLarge(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges, Theme.Spacing.extraLarge.value)
    }
    
    /// Applies theme corner radius
    /// - Parameter radius: The corner radius value
    /// - Returns: View with corner radius applied
    func themeCornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}