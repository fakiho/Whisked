//
//  WhiskedDessertDetailView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit

/// View displaying detailed information about a specific dessert with hero animations
struct WhiskedDessertDetailView: View {
    
    // MARK: - Properties
    
    private let coordinator: WhiskedMainCoordinator
    private let mealID: String
    @State private var viewModel: DessertDetailViewModel
    
    // Hero animation namespace (optional for legacy support)
    private let heroAnimationNamespace: Namespace.ID?
    
    // Animation states
    @State private var contentOpacity: Double = 0
    @State private var isImageLoaded = false
    
    // Device and screen size detection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // MARK: - Initialization
    
    init(
        mealID: String, 
        coordinator: WhiskedMainCoordinator, 
        viewModel: DessertDetailViewModel,
        heroAnimationNamespace: Namespace.ID? = nil
    ) {
        self.mealID = mealID
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.heroAnimationNamespace = heroAnimationNamespace
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle("Recipe")
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
        .accessibilityLabel("Recipe details for \(mealDetail.strMeal)")
    }
    
    @ViewBuilder
    private func contentSections(mealDetail: MealDetail) -> some View {
        // Ingredients Section
        ingredientsSection(ingredients: mealDetail.ingredients)
            .opacity(contentOpacity)
            .scaleEffect(contentOpacity * 0.2 + 0.8)
            .animation(.easeOut(duration: 0.6).delay(0.2), value: contentOpacity)
        
        // Instructions Section
        instructionsSection(instructions: mealDetail.instructions)
            .opacity(contentOpacity)
            .scaleEffect(contentOpacity * 0.2 + 0.8)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: contentOpacity)
    }
    
    private func mealHeaderView(mealDetail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.large.value) {
            // Hero Image with responsive layout
            GeometryReader { geometry in
                AsyncImage(url: URL(string: mealDetail.strMealThumb)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: geometry.size.width,
                            height: imageHeight(for: geometry.size)
                        )
                        .clipped()
                        .onAppear {
                            isImageLoaded = true
                        }
                } placeholder: {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .fill(Color.backgroundSecondary)
                        .frame(
                            width: geometry.size.width,
                            height: imageHeight(for: geometry.size)
                        )
                        .overlay {
                            VStack(spacing: Theme.Spacing.medium.value) {
                                Image(systemName: "photo")
                                    .font(.system(size: Theme.IconSize.extraLarge))
                                    .foregroundColor(.textSecondary)
                                
                                Text("Loading image...")
                                    .themeCaption()
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .overlay(ShimmerView())
                }
                .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 20,
                    x: 0,
                    y: 10
                )
                .applyHeroAnimation(
                    id: "dessert-image-\(mealID)",
                    namespace: heroAnimationNamespace,
                    isSource: false  // Detail view is the destination, not source
                )
            }
            .frame(height: adaptiveImageHeight)
            .themePadding(.horizontal, .large)
            
            // Meal Information
            VStack(alignment: .leading, spacing: Theme.Spacing.medium.value) {
                Text(mealDetail.strMeal)
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
                    
                    // Favorite button (placeholder for future implementation)
                    Button(action: {
                        // TODO: Implement favorite functionality
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: Theme.IconSize.medium))
                            .foregroundColor(.textSecondary)
                    }
                    .accessibilityLabel("Add to favorites")
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
            
            LazyVGrid(
                columns: adaptiveGridColumns,
                spacing: Theme.Spacing.medium.value
            ) {
                ForEach(Array(ingredients.enumerated()), id: \.element.id) { index, ingredient in
                    IngredientCard(ingredient: ingredient)
                        .opacity(contentOpacity)
                        .scaleEffect(contentOpacity * 0.2 + 0.8)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.05),
                            value: contentOpacity
                        )
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

private struct IngredientCard: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
            Text(ingredient.name)
                .themeHeadline()
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(ingredient.measure)
                .themeBody()
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .themePadding(.all, .medium)
        .background(Color.backgroundSecondary)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(
            color: Color.black.opacity(0.03),
            radius: 4,
            x: 0,
            y: 2
        )
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

private extension WhiskedDessertDetailView {
    
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
    
    /// Calculates responsive image height based on available space
    func imageHeight(for size: CGSize) -> CGFloat {
        let aspectRatio: CGFloat = 16/9  // Standard aspect ratio for food images
        let maxHeight = adaptiveImageHeight
        
        // Calculate height based on width and aspect ratio
        let calculatedHeight = size.width / aspectRatio
        
        // Return the smaller of calculated height or max height
        return min(calculatedHeight, maxHeight)
    }
    
    /// Adaptive content layout for different screen sizes
    var shouldUseCompactLayout: Bool {
        horizontalSizeClass == .compact || isLandscape
    }
    
    /// Adaptive grid columns for ingredients based on screen size
    var adaptiveGridColumns: [GridItem] {
        let columnCount = isIpad ? 3 : 2  // 3 columns on iPad, 2 on iPhone
        return Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.medium.value), count: columnCount)
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

// MARK: - Previews

#Preview("Success State") {
    @Previewable @Namespace var heroNamespace
    return NavigationStack {
        WhiskedDessertDetailView(
            mealID: "52893",
            coordinator: WhiskedMainCoordinator(),
            viewModel: DessertDetailViewModel(
                mealID: "52893",
                networkService: MockNetworkService.success()
            ),
            heroAnimationNamespace: heroNamespace
        )
    }
}

#Preview("Error State") {
    @Previewable @Namespace var heroNamespace
    return NavigationStack {
        WhiskedDessertDetailView(
            mealID: "invalid",
            coordinator: WhiskedMainCoordinator(),
            viewModel: DessertDetailViewModel(
                mealID: "invalid",
                networkService: MockNetworkService.notFoundError()
            ),
            heroAnimationNamespace: heroNamespace
        )
    }
}
