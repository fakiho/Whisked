//
//  ThemeKitTests.swift
//  ThemeKitTests
//
//  Created by ThemeKit on 10/5/25.
//

import XCTest
@testable import ThemeKit
import SwiftUI

final class ThemeKitTests: XCTestCase {
    
    func testThemeKitAvailability() {
        XCTAssertTrue(ThemeKit.isAvailable)
        XCTAssertEqual(ThemeKit.version, "1.0.0")
    }
    
    func testSpacingValues() {
        XCTAssertEqual(Theme.Spacing.extraSmall.value, 4)
        XCTAssertEqual(Theme.Spacing.small.value, 8)
        XCTAssertEqual(Theme.Spacing.medium.value, 16)
        XCTAssertEqual(Theme.Spacing.large.value, 24)
        XCTAssertEqual(Theme.Spacing.extraLarge.value, 32)
        XCTAssertEqual(Theme.Spacing.huge.value, 48)
        
        // Test raw values
        XCTAssertEqual(Theme.Spacing.extraSmall.rawValue, 4)
        XCTAssertEqual(Theme.Spacing.small.rawValue, 8)
        XCTAssertEqual(Theme.Spacing.medium.rawValue, 16)
        XCTAssertEqual(Theme.Spacing.large.rawValue, 24)
        XCTAssertEqual(Theme.Spacing.extraLarge.rawValue, 32)
        XCTAssertEqual(Theme.Spacing.huge.rawValue, 48)
    }
    
    func testCornerRadiusValues() {
        XCTAssertEqual(Theme.CornerRadius.small, 4)
        XCTAssertEqual(Theme.CornerRadius.medium, 8)
        XCTAssertEqual(Theme.CornerRadius.large, 12)
        XCTAssertEqual(Theme.CornerRadius.extraLarge, 16)
        XCTAssertEqual(Theme.CornerRadius.circle, 50)
    }
    
    func testIconSizeValues() {
        XCTAssertEqual(Theme.IconSize.small, 16)
        XCTAssertEqual(Theme.IconSize.medium, 24)
        XCTAssertEqual(Theme.IconSize.large, 32)
        XCTAssertEqual(Theme.IconSize.extraLarge, 48)
    }
    
    func testLayoutValues() {
        XCTAssertEqual(Theme.Layout.buttonHeight, 44)
        XCTAssertEqual(Theme.Layout.buttonHeightCompact, 36)
        XCTAssertEqual(Theme.Layout.inputHeight, 44)
        XCTAssertEqual(Theme.Layout.listRowHeight, 56)
        XCTAssertEqual(Theme.Layout.maxContentWidth, 600)
    }
    
    func testColorExtensions() {
        // Test that color extensions exist and return Color values
        XCTAssertNotNil(Color.backgroundPrimary)
        XCTAssertNotNil(Color.backgroundSecondary)
        XCTAssertNotNil(Color.textPrimary)
        XCTAssertNotNil(Color.textSecondary)
        XCTAssertNotNil(Color.accent)
        XCTAssertNotNil(Color.success)
        XCTAssertNotNil(Color.warning)
        XCTAssertNotNil(Color.error)
    }
    
    func testFontExtensions() {
        // Test that font extensions exist and return Font values
        XCTAssertNotNil(Font.themeDisplayLarge())
        XCTAssertNotNil(Font.themeHeadline())
        XCTAssertNotNil(Font.themeBody())
        XCTAssertNotNil(Font.themeCaption())
        XCTAssertNotNil(Font.themeButton())
    }
    
    func testEdgeInsetsExtensions() {
        let small = EdgeInsets.themeSmall
        XCTAssertEqual(small.top, Theme.Spacing.small.value)
        XCTAssertEqual(small.leading, Theme.Spacing.small.value)
        XCTAssertEqual(small.bottom, Theme.Spacing.small.value)
        XCTAssertEqual(small.trailing, Theme.Spacing.small.value)
        
        let custom = EdgeInsets.theme(horizontal: 10, vertical: 20)
        XCTAssertEqual(custom.top, 20)
        XCTAssertEqual(custom.leading, 10)
        XCTAssertEqual(custom.bottom, 20)
        XCTAssertEqual(custom.trailing, 10)
    }
}