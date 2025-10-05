//
//  Font+Theme.swift
//  ThemeKit
//
//  Created by ThemeKit on 10/5/25.
//

import SwiftUI

public extension Font {
    
    // MARK: - Display Fonts
    
    /// Large display title for hero sections
    /// Supports Dynamic Type scaling
    static func themeDisplayLarge() -> Font {
        return .system(.largeTitle, design: .default, weight: .bold)
    }
    
    /// Medium display title for section headers
    /// Supports Dynamic Type scaling
    static func themeDisplayMedium() -> Font {
        return .system(.title, design: .default, weight: .semibold)
    }
    
    /// Small display title for subsection headers
    /// Supports Dynamic Type scaling
    static func themeDisplaySmall() -> Font {
        return .system(.title2, design: .default, weight: .medium)
    }
    
    // MARK: - Headline Fonts
    
    /// Primary headline for important content
    /// Supports Dynamic Type scaling
    static func themeHeadline() -> Font {
        return .system(.headline, design: .default, weight: .semibold)
    }
    
    /// Secondary headline for less prominent content
    /// Supports Dynamic Type scaling
    static func themeHeadlineSecondary() -> Font {
        return .system(.headline, design: .default, weight: .medium)
    }
    
    // MARK: - Body Fonts
    
    /// Primary body text for main content
    /// Supports Dynamic Type scaling
    static func themeBody() -> Font {
        return .system(.body, design: .default, weight: .regular)
    }
    
    /// Secondary body text for supporting content
    /// Supports Dynamic Type scaling
    static func themeBodySecondary() -> Font {
        return .system(.callout, design: .default, weight: .regular)
    }
    
    /// Emphasis body text for highlighted content
    /// Supports Dynamic Type scaling
    static func themeBodyEmphasis() -> Font {
        return .system(.body, design: .default, weight: .medium)
    }
    
    // MARK: - Caption Fonts
    
    /// Primary caption for supplementary information
    /// Supports Dynamic Type scaling
    static func themeCaption() -> Font {
        return .system(.caption, design: .default, weight: .regular)
    }
    
    /// Secondary caption for additional details
    /// Supports Dynamic Type scaling
    static func themeCaptionSecondary() -> Font {
        return .system(.caption2, design: .default, weight: .regular)
    }
    
    /// Emphasis caption for important supplementary info
    /// Supports Dynamic Type scaling
    static func themeCaptionEmphasis() -> Font {
        return .system(.caption, design: .default, weight: .medium)
    }
    
    // MARK: - Button Fonts
    
    /// Primary button text
    /// Supports Dynamic Type scaling
    static func themeButton() -> Font {
        return .system(.callout, design: .default, weight: .semibold)
    }
    
    /// Secondary button text for less prominent buttons
    /// Supports Dynamic Type scaling
    static func themeButtonSecondary() -> Font {
        return .system(.callout, design: .default, weight: .medium)
    }
    
    // MARK: - Label Fonts
    
    /// Primary label for form fields and controls
    /// Supports Dynamic Type scaling
    static func themeLabel() -> Font {
        return .system(.subheadline, design: .default, weight: .medium)
    }
    
    /// Secondary label for supplementary controls
    /// Supports Dynamic Type scaling
    static func themeLabelSecondary() -> Font {
        return .system(.footnote, design: .default, weight: .regular)
    }
}

// MARK: - Text Style Modifiers

public extension Text {
    
    /// Applies theme display large styling
    func themeDisplayLarge() -> some View {
        self.font(.themeDisplayLarge())
            .foregroundColor(.primary)
            .lineLimit(nil)
    }
    
    /// Applies theme display medium styling
    func themeDisplayMedium() -> some View {
        self.font(.themeDisplayMedium())
            .foregroundColor(.primary)
            .lineLimit(nil)
    }
    
    /// Applies theme headline styling
    func themeHeadline() -> some View {
        self.font(.themeHeadline())
            .foregroundColor(.primary)
            .lineLimit(nil)
    }
    
    /// Applies theme body styling
    func themeBody() -> some View {
        self.font(.themeBody())
            .foregroundColor(.primary)
            .lineLimit(nil)
    }
    
    /// Applies theme body secondary styling
    func themeBodySecondary() -> some View {
        self.font(.themeBodySecondary())
            .foregroundColor(.secondary)
            .lineLimit(nil)
    }
    
    /// Applies theme caption styling
    func themeCaption() -> some View {
        self.font(.themeCaption())
            .foregroundColor(.secondary)
            .lineLimit(nil)
    }
    
    /// Applies theme button styling
    func themeButton() -> some View {
        self.font(.themeButton())
            .foregroundColor(.blue)
    }
}