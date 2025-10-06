//
//  ShimmerView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit

// MARK: - ShimmerView

/// A reusable shimmer effect view that creates an animated gradient sweep
/// Used for loading states across the application
struct ShimmerView: View {
    
    // MARK: - Properties
    
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    private let animation: Animation
    
    // MARK: - Initialization
    
    init() {
        self.animation = Animation
            .linear(duration: 1.5)
            .repeatForever(autoreverses: false)
    }
    
    // MARK: - Computed Properties
    
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.backgroundSecondary,
                Color.backgroundSecondary.opacity(0.6),
                Color.backgroundTertiary,
                Color.backgroundSecondary.opacity(0.6),
                Color.backgroundSecondary
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        Rectangle()
            .fill(gradient)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.3),
                                .black,
                                .black.opacity(0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(x: 3, y: 1)
                    .offset(x: isAnimating ? 300 : -300)
            )
            .onAppear {
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .accessibilityHidden(true)
    }
}

// MARK: - ShimmerModifier

/// View modifier that applies shimmer effect to any view
struct ShimmerModifier: ViewModifier {
    
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .redacted(reason: .placeholder)
                .overlay(ShimmerView())
        } else {
            content
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies shimmer effect when loading
    /// - Parameter isLoading: Whether to show the shimmer effect
    /// - Returns: View with conditional shimmer overlay
    func shimmer(isLoading: Bool) -> some View {
        modifier(ShimmerModifier(isLoading: isLoading))
    }
}

// MARK: - Shimmer Skeleton Components

/// Pre-built shimmer skeleton components for common UI elements

struct ShimmerMealCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium.value) {
            // Image placeholder
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(Color.backgroundTertiary)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
                // Title placeholder
                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                    .fill(Color.backgroundTertiary)
                    .frame(height: 20)
                
                // Subtitle placeholder
                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                    .fill(Color.backgroundTertiary)
                    .frame(width: 120, height: 14)
                
                Spacer()
            }
            
            Spacer()
            
            // Chevron placeholder
            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                .fill(Color.backgroundTertiary)
                .frame(width: 12, height: 12)
        }
        .themePadding(.all, .medium)
        .background(Color.backgroundSecondary)
        .cornerRadius(Theme.CornerRadius.large)
        .overlay(ShimmerView())
        .accessibilityHidden(true)
    }
}

struct ShimmerMealGrid: View {
    let itemCount: Int
    
    init(itemCount: Int = 6) {
        self.itemCount = itemCount
    }
    
    var body: some View {
        LazyVStack(spacing: Theme.Spacing.medium.value) {
            ForEach(0..<itemCount, id: \.self) { _ in
                ShimmerMealCard()
            }
        }
        .themePadding(.all, .medium)
    }
}

/// Shimmer component for category grid cards
struct ShimmerCategoryGrid: View {
    let itemCount: Int
    
    init(itemCount: Int = 4) {
        self.itemCount = itemCount
    }
    
    // Fixed grid columns matching CategoryListView to prevent overlapping
    private var gridColumns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad: 3 fixed columns with flexible sizing
            return Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.medium.value), count: 3)
        } else {
            // iPhone: 2 fixed columns with flexible sizing
            return Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.medium.value), count: 2)
        }
    }
    
    var body: some View {
        LazyVGrid(
            columns: gridColumns,
            spacing: Theme.Spacing.medium.value
        ) {
            ForEach(0..<itemCount, id: \.self) { _ in
                ShimmerCategoryCard()
            }
        }
    }
}

/// Individual shimmer card for categories in grid layout
struct ShimmerCategoryCard: View {
    
    // Device-specific sizing matching CategoryGridCard
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var cardSpacing: CGFloat {
        isIPad ? 16 : 12
    }
    
    private var cardPadding: CGFloat {
        isIPad ? 20 : 16
    }
    
    private var cornerRadius: CGFloat {
        isIPad ? 20 : 16
    }
    
    private var imageAspectRatio: CGFloat {
        isIPad ? 4/3 : 3/2  // Slightly taller on iPad for better proportions
    }
    
    var body: some View {
        VStack(spacing: cardSpacing) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
                .aspectRatio(imageAspectRatio, contentMode: .fit)
            
            VStack(spacing: isIPad ? 6 : 4) {
                // Title placeholder
                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                    .fill(Color.backgroundTertiary)
                    .frame(height: isIPad ? 20 : 16)
                
                // Description placeholder
                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                    .fill(Color.backgroundTertiary)
                    .frame(height: isIPad ? 16 : 12)
                    .frame(maxWidth: isIPad ? 120 : 100)
                
                // Additional description line for iPad
                if isIPad {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                        .fill(Color.backgroundTertiary)
                        .frame(height: 14)
                        .frame(maxWidth: 90)
                }
            }
            .padding(.horizontal, isIPad ? 12 : 8)
            .frame(minHeight: isIPad ? 70 : 50) // More space for text on iPad
        }
        .padding(cardPadding)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.backgroundSecondary)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: isIPad ? 12 : 8,
                    x: 0,
                    y: isIPad ? 4 : 2
                )
        }
        .overlay(ShimmerView())
        .accessibilityHidden(true)
    }
}

// MARK: - Preview

#Preview("Shimmer View") {
    VStack(spacing: 20) {
        Text("Shimmer Effect Demo")
            .themeHeadline()
        
        ShimmerMealCard()

        Text("Grid Example")
            .themeBody()
        
        ShimmerMealGrid(itemCount: 3)
    }
    .themePadding(.all, .large)
    .background(Color.backgroundPrimary)
}

#Preview("Shimmer Modifier") {
    VStack(spacing: 20) {
        Text("Loading State")
            .themeHeadline()
            .shimmer(isLoading: true)
        
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.backgroundSecondary)
            .frame(height: 100)
            .shimmer(isLoading: true)
        
        HStack {
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .fill(Color.accent)
                    .frame(width: 50, height: 50)
                    .shimmer(isLoading: true)
            }
        }
    }
    .themePadding(.all, .large)
    .background(Color.backgroundPrimary)
}
