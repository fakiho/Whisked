//
//  Color+Theme.swift
//  ThemeKit
//
//  Created by ThemeKit on 10/5/25.
//

import SwiftUI

public extension Color {
    
    // MARK: - Background Colors
    
    /// Primary background color that adapts to light/dark mode
    /// Uses SwiftUI's automatic adaptation for light/dark mode
    static let backgroundPrimary: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    /// Secondary background color for cards, sections, etc.
    static let backgroundSecondary: Color = Color(red: 0.97, green: 0.97, blue: 0.97)
    
    /// Tertiary background color for subtle elements
    static let backgroundTertiary: Color = Color(red: 0.94, green: 0.94, blue: 0.96)
    
    // MARK: - Text Colors
    
    /// Primary text color for main content
    static let textPrimary: Color = .primary
    
    /// Secondary text color for less prominent content
    static let textSecondary: Color = .secondary
    
    /// Tertiary text color for subtle text
    static let textTertiary: Color = Color.gray
    
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
    static let borderPrimary: Color = Color.gray.opacity(0.3)
    
    /// Secondary border color for subtle dividers
    static let borderSecondary: Color = Color.gray.opacity(0.2)
}