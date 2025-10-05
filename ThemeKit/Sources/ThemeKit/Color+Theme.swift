//
//  Color+Theme.swift
//  ThemeKit
//
//  Created by ThemeKit on 10/5/25.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public extension Color {
    
    // MARK: - Background Colors
    
    /// Primary background color that adapts to light/dark mode
    /// Uses SwiftUI's automatic adaptation for light/dark mode
    static let backgroundPrimary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.systemBackground)
        #else
        return Color(NSColor.controlBackgroundColor)
        #endif
    }()
    
    /// Secondary background color for cards, sections, etc.
    static let backgroundSecondary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.secondarySystemBackground)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }()
    
    /// Tertiary background color for subtle elements
    static let backgroundTertiary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.tertiarySystemBackground)
        #else
        return Color.gray.opacity(0.05)
        #endif
    }()
    
    // MARK: - Text Colors
    
    /// Primary text color for main content
    static let textPrimary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.label)
        #else
        return Color.primary
        #endif
    }()
    
    /// Secondary text color for less prominent content
    static let textSecondary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.secondaryLabel)
        #else
        return Color.secondary
        #endif
    }()
    
    /// Tertiary text color for subtle text
    static let textTertiary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.tertiaryLabel)
        #else
        return Color.gray
        #endif
    }()
    
    // MARK: - Accent Colors
    
    /// Primary brand accent color for buttons, highlights, etc.
    static let accent: Color = .blue
    
    /// Secondary accent color for complementary elements
    static let accentSecondary: Color = .pink
    
    // MARK: - Status Colors
    
    /// Success color for positive states
    static let success: Color = .green
    
    /// Warning color for cautionary states
    static let warning: Color = .orange
    
    /// Error color for negative states
    static let error: Color = .red
    
    // MARK: - Border Colors
    
    /// Primary border color for dividers, outlines
    static let borderPrimary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.separator)
        #else
        return Color.gray.opacity(0.3)
        #endif
    }()
    
    /// Secondary border color for subtle dividers
    static let borderSecondary: Color = {
        #if canImport(UIKit)
        return Color(UIColor.opaqueSeparator)
        #else
        return Color.gray.opacity(0.2)
        #endif
    }()
}