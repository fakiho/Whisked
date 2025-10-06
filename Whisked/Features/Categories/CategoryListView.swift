//
//  CategoryListView.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/5/25.
//

import SwiftUI
import ThemeKit

/// View displaying available meal categories for user selection
struct CategoryListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: CategoryListViewModel

    // MARK: - Device-specific Grid Layout
    
    /// Fixed grid columns based on device type to prevent overlapping
    private var gridColumns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad: 3 fixed columns with flexible sizing
            return Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.medium.value), count: 3)
        } else {
            // iPhone: 2 fixed columns with flexible sizing
            return Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.medium.value), count: 2)
        }
    }
    
    // MARK: - Initialization
    
    init(viewModel: CategoryListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle(LocalizedStrings.categoriesNavigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.load()
            }
            .refreshable {
                await viewModel.refresh()
            }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.loadingState {
        case .idle, .loading:
            loadingView
            
        case .loaded(let categories):
            if viewModel.allCategories.isEmpty {
                emptyView
            } else {
                loadedView(categories: categories)
            }
            
        case .failed(let error):
            errorView(error: error)
        }
    }

    private var emptyView: some View {
        VStack(spacing: Theme.Spacing.large.value) {
            Image(systemName: "tray")
                .font(.system(size: Theme.IconSize.extraLarge))
                .foregroundStyle(.secondary)
                .accessibilityLabel(LocalizedStrings.accessibilityCategoryImage)

            Text(LocalizedStrings.categoriesEmptyTitle)
                .font(.title2)
                .foregroundStyle(.primary)

            Text(LocalizedStrings.categoriesEmptyDescription)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .themePaddingLarge()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityEmptyView)
    }

    private var loadingView: some View {
        VStack(spacing: Theme.Spacing.large.value) {
            // Hero section with shimmer
            VStack(spacing: Theme.Spacing.medium.value) {
                Text(LocalizedStrings.categoriesLoading)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .themePadding(.top, Theme.Spacing.large)
                
                Text(LocalizedStrings.categoriesLoadingDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .themePaddingMedium(.horizontal)
            
            // Grid shimmer with improved padding
            ShimmerCategoryGrid(itemCount: 6) // 6 categories in 2-column grid
                .themePadding(.horizontal, Theme.Spacing.large)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityLoadingView)
        .accessibilityHint(LocalizedStrings.accessibilityLoadingHint)
    }
    
    private func loadedView(categories: [MealCategory]) -> some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium.value) {
                // Favorites card - always show at the top
                FavoritesCard(
                    favoritesCount: viewModel.favoritesCount,
                    onTap: {
                        viewModel.handleFavoritesSelection()
                    }
                )

                // Categories grid with device-specific adaptive sizing
                LazyVGrid(
                    columns: gridColumns,
                    spacing: Theme.Spacing.medium.value
                ) {
                    ForEach(Array(viewModel.allCategories.enumerated()), id: \.element.id) { index, category in
                        CategoryGridCard(
                            category: category,
                            onTap: {
                                viewModel.handleCategorySelection(category)
                            }
                        )
                    }
                }
                .themePadding(.horizontal, Theme.Spacing.large)
            }
            .themePaddingMedium()
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: Theme.Spacing.large.value) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: Theme.IconSize.extraLarge))
                .foregroundStyle(.red)
                .accessibilityLabel(LocalizedStrings.accessibilityErrorLoading)
            
            Text(LocalizedStrings.categoriesErrorTitle)
                .font(.title2)
                .foregroundStyle(.primary)
            
            Text(LocalizedStrings.categoriesErrorDescription)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(LocalizedStrings.categoriesRetryButton) {
                Task {
                    await viewModel.load()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityHint(LocalizedStrings.accessibilityRetryHint)
        }
        .themePaddingLarge()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityErrorView)
    }
}

// MARK: - Category Card

private struct CategoryCard: View {
    
    let category: MealCategory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Theme.Spacing.medium.value) {
                AsyncImage(url: URL(string: category.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .fill(Color.backgroundSecondary)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: Theme.IconSize.medium))
                                .foregroundStyle(.secondary)
                        }
                }
                .frame(width: 80, height: 80)
                .themeCornerRadius(Theme.CornerRadius.large)
                
                VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
                    Text(category.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(category.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body.weight(.medium))
                    .foregroundStyle(.tertiary)
            }
            .themePaddingMedium()
            .background {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.extraLarge)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: Theme.Spacing.small.value,
                        x: 0,
                        y: 2
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Category Grid Card

private struct CategoryGridCard: View {
    
    let category: MealCategory
    let onTap: () -> Void
    
    // Device-specific sizing using theme values
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var cardSpacing: CGFloat {
        isIPad ? Theme.Spacing.medium.value : Theme.Spacing.small.value
    }
    
    private var cardPadding: CGFloat {
        isIPad ? Theme.Spacing.large.value : Theme.Spacing.medium.value
    }
    
    private var cornerRadius: CGFloat {
        isIPad ? Theme.CornerRadius.extraLarge : Theme.CornerRadius.extraLarge
    }
    
    private var imageAspectRatio: CGFloat {
        isIPad ? 16/9 : 3/2
    }
    
    private var titleFont: Font {
        isIPad ? .title3 : .headline
    }
    
    private var descriptionFont: Font {
        isIPad ? .body : .caption
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: cardSpacing) {
                AsyncImage(url: URL(string: category.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                        .fill(Color.backgroundSecondary)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: isIPad ? Theme.IconSize.extraLarge : Theme.IconSize.large))
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityLabel(LocalizedStrings.accessibilityCategoryImage)
                }
                .aspectRatio(imageAspectRatio, contentMode: .fit)
                .themeCornerRadius(Theme.CornerRadius.large)
                
                VStack(spacing: isIPad ? Theme.Spacing.small.value : Theme.Spacing.extraSmall.value) {
                    Text(category.name)
                        .font(titleFont)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(category.description)
                        .font(descriptionFont)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(isIPad ? 3 : 2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .themePadding(.horizontal, isIPad ? Theme.Spacing.small : Theme.Spacing.extraSmall)
                .frame(minHeight: isIPad ? 70 : 50)
            }
            .padding(cardPadding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: isIPad ? Theme.Spacing.small.value : Theme.Spacing.extraSmall.value,
                        x: 0,
                        y: isIPad ? Theme.Spacing.extraSmall.value : 2
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(LocalizedStrings.accessibilityCategoryCard), \(category.name)")
        .accessibilityHint(LocalizedStrings.accessibilityCategoryCardHint)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Favorites Card

private struct FavoritesCard: View {
    
    let favoritesCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Theme.Spacing.medium.value) {
                // SF Symbol heart icon
                Image(systemName: "heart.fill")
                    .font(.system(size: Theme.IconSize.large))
                    .foregroundStyle(.red)
                    .frame(width: 80, height: 80)
                    .background {
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .fill(Color.red.opacity(0.1))
                    }
                
                VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
                    Text(LocalizedStrings.favoritesCardTitle)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(favoritesCount == 0 ? LocalizedStrings.favoritesCountZero : LocalizedStrings.favoritesCount(favoritesCount))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body.weight(.medium))
                    .foregroundStyle(.tertiary)
            }
            .themePaddingMedium()
            .background {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.extraLarge)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: Theme.Spacing.small.value,
                        x: 0,
                        y: 2
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(LocalizedStrings.accessibilityFavoritesCard), \(favoritesCount == 0 ? LocalizedStrings.favoritesCountZero : LocalizedStrings.favoritesCount(favoritesCount))")
        .accessibilityHint(LocalizedStrings.accessibilityFavoritesCardHint)
        .accessibilityAddTraits(.isButton)
    }
}
