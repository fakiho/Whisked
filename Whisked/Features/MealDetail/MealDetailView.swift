//
//  MealDetailView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit
import NetworkKit

/// View displaying detailed information about a specific meal with hero animations
struct MealDetailView: View {
    
    // MARK: - Properties
    
    private let coordinator: WhiskedMainCoordinator
    private let mealID: String
    @State private var viewModel: MealDetailViewModel
    
    // Animation states
    @State private var contentOpacity: Double = 0
    @State private var imageOpacity: Double = 0
    @State private var isImageLoaded = false
    
    // Device and screen size detection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // MARK: - Initialization
    
    init(
        mealID: String, 
        coordinator: WhiskedMainCoordinator, 
        viewModel: MealDetailViewModel
    ) {
        self.mealID = mealID
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle(LocalizedStrings.uiRecipe)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundPrimary)
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                if viewModel.state.mealDetail == nil {
                    await viewModel.fetchMealDetails()
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    contentOpacity = 1
                }
                withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                    imageOpacity = 1
                }
            }
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .success(let mealDetail):
            detailScrollView(mealDetail: mealDetail)
        case .error:
            errorView
        }
    }
    
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.extraLarge.value) {
                // Hero shimmer placeholder
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(Color.backgroundSecondary)
                    .frame(height: 280)
                    .overlay(ShimmerView())
                    .themePadding(.horizontal, .large)
                    .themePadding(.top, .medium)
                
                VStack(spacing: Theme.Spacing.large.value) {
                    Text("Loading recipe details...")
                        .themeHeadline()
                        .foregroundColor(.textSecondary)
                    
                    // Content shimmers
                    VStack(spacing: Theme.Spacing.medium.value) {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(Color.backgroundSecondary)
                                .frame(height: 80)
                                .overlay(ShimmerView())
                        }
                    }
                    .themePadding(.horizontal, .large)
                }
            }
        }
        .background(Color.backgroundPrimary)
        .accessibilityLabel("Loading recipe details")
    }
    
    private func detailScrollView(mealDetail: MealDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.extraLarge.value) {
                // Hero header
                mealHeaderView(mealDetail: mealDetail)
                
                // Content sections with adaptive layout
                if isIpad && !isLandscape {
                    // iPad portrait: wider content layout
                    VStack(alignment: .leading, spacing: Theme.Spacing.extraLarge.value) {
                        contentSections(mealDetail: mealDetail)
                    }
                    .frame(maxWidth: Theme.Layout.maxContentWidth)
                    .frame(maxWidth: .infinity)
                } else {
                    // iPhone and iPad landscape: standard layout
                    VStack(alignment: .leading, spacing: Theme.Spacing.extraLarge.value) {
                        contentSections(mealDetail: mealDetail)
                    }
                    .themePadding(.horizontal, .large)
                }
                
                // Bottom spacing
                Spacer(minLength: Theme.Spacing.huge.value)
            }
        }
        .background(Color.backgroundPrimary)
        .accessibilityLabel("Recipe details for \(mealDetail.name)")
    }
    
    @ViewBuilder
    private func contentSections(mealDetail: MealDetail) -> some View {
        // Ingredients Section
        ingredientsSection(ingredients: mealDetail.ingredients)
            .opacity(contentOpacity)
        
        // Instructions Section
        instructionsSection(instructions: mealDetail.instructions)
            .opacity(contentOpacity)
    }
    
    private func mealHeaderView(mealDetail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large.value) {
            // Recipe header image with smooth fade-in animation
            AsyncImage(url: URL(string: mealDetail.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: adaptiveImageHeight)
                    .clipped()
                    .opacity(imageOpacity)
                    .animation(.easeOut(duration: 0.4), value: imageOpacity)
                    .onAppear {
                        isImageLoaded = true
                    }
            } placeholder: {
                Rectangle()
                    .fill(Color.backgroundSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: adaptiveImageHeight)
                    .overlay {
                        VStack(spacing: Theme.Spacing.medium.value) {
                            Image(systemName: "photo")
                                .font(.system(size: Theme.IconSize.extraLarge))
                                .foregroundColor(.textSecondary)
                            
                            Text("Loading image...")
                                .themeCaption()
                                .foregroundColor(.textSecondary)
                        }
                        .opacity(0.7)
                    }
                    .overlay(ShimmerView())
                    .opacity(imageOpacity)
                    .animation(.easeOut(duration: 0.4), value: imageOpacity)
            }
            .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 20,
                x: 0,
                y: 10
            )
            .themePadding(.horizontal, .large)
            
            // Meal Information
            VStack(alignment: .leading, spacing: Theme.Spacing.medium.value) {
                Text(mealDetail.name)
                    .themeDisplayLarge()
                    .foregroundColor(.textPrimary)
                    .opacity(contentOpacity)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: contentOpacity)
                
                HStack(spacing: Theme.Spacing.small.value) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: Theme.IconSize.small))
                        .foregroundColor(.accent)
                    
                    Text("Recipe Details")
                        .themeBody()
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    // Favorite button with improved functionality
                    Button(action: {
                        Task {
                            await viewModel.toggleFavorite()
                        }
                    }) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: Theme.IconSize.medium, weight: .medium))
                            .foregroundColor(viewModel.isFavorite ? .error : .textSecondary)
                            .scaleEffect(viewModel.isFavorite ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isFavorite)
                    }
                    .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
                    .accessibilityHint(viewModel.isFavorite ? "Double tap to remove this recipe from favorites" : "Double tap to save this recipe for offline viewing")
                }
                .opacity(contentOpacity)
                .animation(.easeOut(duration: 0.6).delay(0.15), value: contentOpacity)
            }
            .themePadding(.horizontal, .large)
        }
    }
    
    private func ingredientsSection(ingredients: [Ingredient]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large.value) {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: Theme.IconSize.medium))
                    .foregroundColor(.accent)
                
                Text("Ingredients")
                    .themeHeadline()
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(ingredients.count) items")
                    .themeCaption()
                    .foregroundColor(.textSecondary)
                    .themePadding(.horizontal, .small)
                    .themePadding(.vertical, .extraSmall)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(Theme.CornerRadius.small)
            }
            
            // Simple vertical stack with manual column layout
            VStack(spacing: Theme.Spacing.medium.value) {
                ForEach(ingredients.chunked(into: isIpad ? 3 : 2), id: \.self) { row in
                    HStack(spacing: Theme.Spacing.medium.value) {
                        ForEach(row, id: \.id) { ingredient in
                            IngredientCard(ingredient: ingredient)
                                .frame(maxWidth: .infinity)
                        }
                        
                        // Fill remaining space if row is incomplete
                        if row.count < (isIpad ? 3 : 2) {
                            ForEach(0..<((isIpad ? 3 : 2) - row.count), id: \.self) { _ in
                                Color.clear
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Ingredients section with \(ingredients.count) items")
    }
    
    private func instructionsSection(instructions: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large.value) {
            HStack {
                Image(systemName: "text.document")
                    .font(.system(size: Theme.IconSize.medium))
                    .foregroundColor(.accent)
                
                Text("Instructions")
                    .themeHeadline()
                    .foregroundColor(.textPrimary)
            }
            
            Text(instructions)
                .themeBody()
                .foregroundColor(.textPrimary)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
                .themePadding(.all, .large)
                .background(Color.backgroundSecondary)
                .cornerRadius(Theme.CornerRadius.large)
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Cooking instructions")
    }
    
    private var errorView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: Theme.Spacing.extraLarge.value) {
                    Spacer(minLength: 100)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.error)
                    
                    VStack(spacing: Theme.Spacing.medium.value) {
                        Text("Recipe Not Available")
                            .themeDisplayLarge()
                            .foregroundColor(.textPrimary)
                        
                        Text(viewModel.state.errorMessage ?? "Unable to load recipe details")
                            .themeBody()
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .themePadding(.horizontal, .large)
                    }
                    
                    Button("Try Again") {
                        Task {
                            await viewModel.retry()
                        }
                    }
                    .themeButton()
                    
                    Spacer(minLength: 100)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height - 100)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .background(Color.backgroundPrimary)
        .accessibilityLabel("Error loading recipe")
    }
}

// MARK: - Supporting Views

/// Array extension for chunking ingredients into rows
private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

private struct IngredientCard: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Text(IngredientEmojiMapper.emoji(for: ingredient.name))
                    .font(.system(size: 20))
                    .frame(width: 24, height: 24, alignment: .center)
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(ingredient.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(ingredient.measure)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(ingredient.name): \(ingredient.measure)")
    }
}

// MARK: - Hero Animation Helper

private struct HeroAnimationModifier: ViewModifier {
    let id: String
    let namespace: Namespace.ID?
    let isSource: Bool
    
    func body(content: Content) -> some View {
        if let namespace = namespace {
            content
                .matchedGeometryEffect(id: id, in: namespace, isSource: isSource)
        } else {
            content
        }
    }
}

private extension View {
    func applyHeroAnimation(id: String, namespace: Namespace.ID?, isSource: Bool = false) -> some View {
        modifier(HeroAnimationModifier(id: id, namespace: namespace, isSource: isSource))
    }
}

// MARK: - Responsive Layout Helpers

private extension MealDetailView {
    
    /// Determines if we're running on iPad or large screen
    var isIpad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    /// Determines if we're in landscape orientation
    var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }
    
    /// Adaptive image height based on device and orientation
    var adaptiveImageHeight: CGFloat {
        if isIpad {
            return isLandscape ? 300 : 400  // iPad landscape/portrait
        } else if isLandscape {
            return 200  // iPhone landscape
        } else {
            return 280  // iPhone portrait (default)
        }
    }
    
    /// Adaptive content layout for different screen sizes
    var shouldUseCompactLayout: Bool {
        horizontalSizeClass == .compact || isLandscape
    }
    
    /// Adaptive grid columns for ingredients based on screen size
    var adaptiveGridColumns: [GridItem] {
        let columnCount = isIpad ? 3 : 2  // 3 columns on iPad, 2 on iPhone
        return Array(repeating: GridItem(.flexible(minimum: 140, maximum: 200), spacing: Theme.Spacing.medium.value), count: columnCount)
    }
}

// MARK: - Button Style Extension

private extension Button where Label == Text {
    func themeButton() -> some View {
        self
            .font(.themeButton())
            .foregroundColor(.white)
            .themePadding(.horizontal, .extraLarge)
            .themePadding(.vertical, .medium)
            .background(Color.accent)
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(color: Color.accent.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}
