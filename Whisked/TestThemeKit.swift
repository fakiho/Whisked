//
//  TestThemeKit.swift
//  Whisked
//
//  ThemeKit Integration Test
//

import SwiftUI
import ThemeKit

/// A simple test view to demonstrate ThemeKit integration
struct TestThemeKitView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.large.value) {
            Text("ThemeKit Integration Test")
                .themeHeadline()
                .foregroundColor(.textPrimary)
            
            Text("This demonstrates that ThemeKit is successfully integrated!")
                .themeBody()
                .foregroundColor(.textSecondary)
            
            Rectangle()
                .fill(Color.accent)
                .frame(width: Theme.IconSize.large, height: Theme.IconSize.large)
                .cornerRadius(Theme.CornerRadius.medium)
            
            VStack(spacing: Theme.Spacing.small.value) {
                Text("Success Colors:")
                    .themeCaption()
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: Theme.Spacing.medium.value) {
                    Circle()
                        .fill(Color.success)
                        .frame(width: Theme.IconSize.medium, height: Theme.IconSize.medium)
                    
                    Circle()
                        .fill(Color.warning)
                        .frame(width: Theme.IconSize.medium, height: Theme.IconSize.medium)
                    
                    Circle()
                        .fill(Color.error)
                        .frame(width: Theme.IconSize.medium, height: Theme.IconSize.medium)
                }
            }
        }
        .themePadding(.all, .large)
        .background(Color.backgroundPrimary)
        .cornerRadius(Theme.CornerRadius.large)
        .themePadding(.all, .medium)
        .background(Color.backgroundSecondary)
    }
}

#Preview {
    TestThemeKitView()
}
