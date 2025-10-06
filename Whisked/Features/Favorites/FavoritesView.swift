//
//  FavoritesView.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/5/25.
//

import SwiftUI
import ThemeKit
import PersistenceKit

/// View displaying all favorite meals saved offline
struct FavoritesView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: FavoritesViewModel
    private let coordinator: WhiskedMainCoordinator
    
    // Device detection
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // MARK: - Device Helpers
    
    /// Check if running on iPad
    private var isIpad: Bool {
        horizontalSizeClass == .regular
    }
    
    /// Check if in landscape orientation
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    /// Responsive content padding
    private var contentPadding: CGFloat {
        isIpad ? Theme.Spacing.extraLarge.value : Theme.Spacing.large.value
    }
    
    /// Responsive card spacing
    private var cardSpacing: CGFloat {
        isIpad ? Theme.Spacing.large.value : Theme.Spacing.medium.value
    }
    
    /// Grid columns for favorites layout
    private var gridColumns: [GridItem] {
        if isIpad {
            if isLandscape {
                // iPad landscape: 3 columns
                return Array(repeating: GridItem(.flexible(), spacing: cardSpacing), count: 3)
            } else {
                // iPad portrait: 2 columns
                return Array(repeating: GridItem(.flexible(), spacing: cardSpacing), count: 2)
            }
        } else {
            // iPhone: single column
            return [GridItem(.flexible())]
        }
    }
    
    // MARK: - Initialization
    
    init(coordinator: WhiskedMainCoordinator, persistenceService: PersistenceServiceProtocol?) {
        self._viewModel = StateObject(wrappedValue: FavoritesViewModel(persistenceService: persistenceService))
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle(LocalizedStrings.favoritesNavigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadFavorites()
            }
            .refreshable {
                await viewModel.refreshFavorites()
            }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.loadingState {
        case .idle:
            VStack {
                ProgressView(LocalizedStrings.uiLoadingFavorites)
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loading:
            loadingView
            
        case .loaded(let favorites):
            if favorites.isEmpty {
                emptyStateView
            } else {
                loadedView(favorites: favorites)
            }
            
        case .failed(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        ScrollView {
            if isIpad {
                // iPad: Grid layout for loading
                LazyVGrid(columns: gridColumns, spacing: cardSpacing) {
                    ForEach(0..<6, id: \.self) { _ in
                        FavoriteMealCardShimmerView(isIpad: isIpad)
                    }
                }
                .padding(contentPadding)
            } else {
                // iPhone: Vertical stack
                LazyVStack(spacing: cardSpacing) {
                    ForEach(0..<6, id: \.self) { _ in
                        FavoriteMealCardShimmerView(isIpad: isIpad)
                    }
                }
                .padding(contentPadding)
            }
        }
        .accessibilityLabel(LocalizedStrings.accessibilityLoadingView)
        .accessibilityHint(LocalizedStrings.accessibilityLoadingHint)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: isIpad ? Theme.Spacing.huge.value : Theme.Spacing.extraLarge.value) {
            Image(systemName: "heart")
                .font(.system(size: isIpad ? 80 : 64))
                .foregroundStyle(.secondary)

            VStack(spacing: isIpad ? Theme.Spacing.medium.value : Theme.Spacing.small.value) {
                Text(LocalizedStrings.favoritesEmptyTitle)
                    .font(isIpad ? .largeTitle.weight(.semibold) : .title2.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Text(LocalizedStrings.favoritesEmptyDescription)
                    .font(isIpad ? .title3 : .body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, isIpad ? Theme.Spacing.huge.value : Theme.Spacing.extraLarge.value)
            }
            
            Button(LocalizedStrings.uiExploreMeals) {
                coordinator.popToRoot()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(isIpad ? .large : .regular)
            .font(isIpad ? .title3.weight(.medium) : .body.weight(.medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(contentPadding)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityEmptyView)
    }
    
    private func loadedView(favorites: [FavoriteMeal]) -> some View {
        ScrollView {
            if isIpad {
                // iPad: Grid layout
                LazyVGrid(columns: gridColumns, spacing: cardSpacing) {
                    ForEach(Array(favorites.enumerated()), id: \.element.id) { index, favorite in
                        FavoriteMealCard(
                            favorite: favorite,
                            isIpad: isIpad,
                            onTap: {
                                coordinator.showMealDetail(mealId: favorite.idMeal)
                            },
                            onRemove: {
                                Task {
                                    await viewModel.removeFavorite(favorite.idMeal)
                                }
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
                            .delay(Double(index) * 0.05),
                            value: viewModel.loadingState
                        )
                    }
                }
                .padding(contentPadding)
            } else {
                // iPhone: Vertical stack
                LazyVStack(spacing: cardSpacing) {
                    ForEach(Array(favorites.enumerated()), id: \.element.id) { index, favorite in
                        FavoriteMealCard(
                            favorite: favorite,
                            isIpad: isIpad,
                            onTap: {
                                coordinator.showMealDetail(mealId: favorite.idMeal)
                            },
                            onRemove: {
                                Task {
                                    await viewModel.removeFavorite(favorite.idMeal)
                                }
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
                            .delay(Double(index) * 0.05),
                            value: viewModel.loadingState
                        )
                    }
                }
                .padding(contentPadding)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityValue(LocalizedStrings.accessibilityRecipeCount(favorites.count))
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            
            Text("Unable to Load Favorites")
                .font(.title2)
                .foregroundStyle(.primary)
            
            Text("There was an error loading your favorite meals.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                Task {
                    await viewModel.loadFavorites()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

// MARK: - Favorite Meal Model

struct FavoriteMeal: Identifiable, Hashable {
    let id = UUID()
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    let ingredients: [Ingredient]
    let dateSaved: Date
}

// MARK: - Favorite Meal Card

private struct FavoriteMealCard: View {
    
    let favorite: FavoriteMeal
    let isIpad: Bool
    let onTap: () -> Void
    let onRemove: () -> Void
    
    // Responsive properties
    private var cardPadding: CGFloat {
        isIpad ? Theme.Spacing.large.value : Theme.Spacing.medium.value
    }
    
    private var imageSize: CGFloat {
        isIpad ? 100 : 80
    }
    
    private var cornerRadius: CGFloat {
        isIpad ? Theme.CornerRadius.large : Theme.CornerRadius.medium
    }
    
    private var cardCornerRadius: CGFloat {
        isIpad ? Theme.CornerRadius.extraLarge : Theme.CornerRadius.large
    }
    
    private var spacing: CGFloat {
        isIpad ? Theme.Spacing.large.value : Theme.Spacing.medium.value
    }
    
    private var contentSpacing: CGFloat {
        isIpad ? Theme.Spacing.medium.value : Theme.Spacing.small.value
    }
    
    private var titleFont: Font {
        isIpad ? .title3.weight(.semibold) : .headline
    }
    
    private var dateFont: Font {
        isIpad ? .callout : .caption
    }
    
    private var ingredientsFont: Font {
        isIpad ? .body : .subheadline
    }
    
    private var iconSize: Font {
        isIpad ? .title3 : .body
    }
    
    var body: some View {
        Button(action: onTap) {
            if isIpad {
                // iPad: Vertical card layout
                VStack(spacing: contentSpacing) {
                    AsyncImage(url: URL(string: favorite.strMealThumb)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.backgroundSecondary)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityLabel(LocalizedStrings.accessibilityMealImage)
                    }
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    
                    VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
                        HStack {
                            Text(favorite.strMeal)
                                .font(titleFont)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                            Spacer()
                            
                            Button(action: onRemove) {
                                Image(systemName: "heart.fill")
                                    .font(iconSize)
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel(LocalizedStrings.accessibilityRemoveFavorite)
                        }
                        
                        Text("Saved \(favorite.dateSaved.formatted(.relative(presentation: .named)))")
                            .font(dateFont)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        
                        Text("\(favorite.ingredients.count) ingredients")
                            .font(ingredientsFont)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                // iPhone: Horizontal card layout
                HStack(spacing: spacing) {
                    AsyncImage(url: URL(string: favorite.strMealThumb)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.backgroundSecondary)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityLabel(LocalizedStrings.accessibilityMealImage)
                    }
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                    VStack(alignment: .leading, spacing: contentSpacing) {
                        Text(favorite.strMeal)
                            .font(titleFont)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)

                        Text("Saved \(favorite.dateSaved.formatted(.relative(presentation: .named)))")
                            .font(dateFont)
                            .foregroundStyle(.secondary)

                        Text("\(favorite.ingredients.count) ingredients")
                            .font(ingredientsFont)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    VStack(spacing: Theme.Spacing.medium.value) {
                        Button(action: onRemove) {
                            Image(systemName: "heart.fill")
                                .font(iconSize)
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel(LocalizedStrings.accessibilityRemoveFavorite)

                        Image(systemName: "chevron.right")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .padding(cardPadding)
        .background {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color.backgroundSecondary)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: isIpad ? 12 : 8,
                    x: 0,
                    y: isIpad ? 4 : 2
                )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityHint(LocalizedStrings.accessibilityMealCardHint)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Favorite Meal Card Shimmer

private struct FavoriteMealCardShimmerView: View {
    let isIpad: Bool
    
    private var cardPadding: CGFloat {
        isIpad ? Theme.Spacing.large.value : Theme.Spacing.medium.value
    }
    
    private var imageSize: CGFloat {
        isIpad ? 100 : 80
    }
    
    private var cornerRadius: CGFloat {
        isIpad ? Theme.CornerRadius.large : Theme.CornerRadius.medium
    }
    
    private var cardCornerRadius: CGFloat {
        isIpad ? Theme.CornerRadius.extraLarge : Theme.CornerRadius.large
    }
    
    private var spacing: CGFloat {
        isIpad ? Theme.Spacing.large.value : Theme.Spacing.medium.value
    }
    
    private var contentSpacing: CGFloat {
        isIpad ? Theme.Spacing.medium.value : Theme.Spacing.small.value
    }
    
    var body: some View {
        if isIpad {
            // iPad: Vertical shimmer layout
            VStack(spacing: contentSpacing) {
                ShimmerView()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
                    ShimmerView()
                        .frame(height: 22)
                        .frame(maxWidth: .infinity)
                    
                    ShimmerView()
                        .frame(height: 16)
                        .frame(maxWidth: 120)
                    
                    ShimmerView()
                        .frame(height: 18)
                        .frame(maxWidth: 100)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            // iPhone: Horizontal shimmer layout
            HStack(spacing: spacing) {
                ShimmerView()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
                VStack(alignment: .leading, spacing: contentSpacing) {
                    ShimmerView()
                        .frame(height: 20)
                        .frame(maxWidth: 160)
                    
                    ShimmerView()
                        .frame(height: 14)
                        .frame(maxWidth: 100)
                    
                    ShimmerView()
                        .frame(height: 16)
                        .frame(maxWidth: 120)
                }
                
                Spacer()
                
                VStack(spacing: Theme.Spacing.medium.value) {
                    ShimmerView()
                        .frame(width: 20, height: 20)
                    
                    ShimmerView()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(cardPadding)
            .background {
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: isIpad ? 12 : 8,
                        x: 0,
                        y: isIpad ? 4 : 2
                    )
            }
        }
    }
}

// MARK: - Previews

#Preview("FavoritesView - Loaded") {
    let coordinator = WhiskedMainCoordinator()
    FavoritesView(coordinator: coordinator, persistenceService: nil)
}

#Preview("FavoritesView - Empty") {
    let coordinator = WhiskedMainCoordinator()
    FavoritesView(coordinator: coordinator, persistenceService: nil)
}
