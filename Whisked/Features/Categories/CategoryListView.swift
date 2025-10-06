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
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 48))
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
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityEmptyView)
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            // Hero section with shimmer
            VStack(spacing: Theme.Spacing.medium.value) {
                Text(LocalizedStrings.categoriesLoading)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                
                Text(LocalizedStrings.categoriesLoadingDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Grid shimmer with improved padding
            ShimmerCategoryGrid(itemCount: 6) // 6 categories in 2-column grid
                .padding(.horizontal, Theme.Spacing.large.value)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityLoadingView)
        .accessibilityHint(LocalizedStrings.accessibilityLoadingHint)
    }
    
    private func loadedView(categories: [MealCategory]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
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
                .padding(.horizontal, Theme.Spacing.large.value)
            }
            .padding()
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
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
        .padding()
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
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: category.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundSecondary)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8) {
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
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 8,
                        x: 0,
                        y: 2
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Category Card Shimmer

private struct CategoryCardShimmerView: View {
    
    var body: some View {
        HStack(spacing: 16) {
            ShimmerView()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                ShimmerView()
                    .frame(height: 20)
                    .frame(maxWidth: 120)
                
                ShimmerView()
                    .frame(height: 16)
                    .frame(maxWidth: 200)
                
                ShimmerView()
                    .frame(height: 16)
                    .frame(maxWidth: 160)
            }
            
            Spacer()
            
            ShimmerView()
                .frame(width: 20, height: 20)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 8,
                    x: 0,
                    y: 2
                )
        }
    }
}

// MARK: - Category Grid Card

private struct CategoryGridCard: View {
    
    let category: MealCategory
    let onTap: () -> Void
    
    // Device-specific sizing
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
        isIPad ? 16/9 : 3/2  // Slightly taller on iPad for better proportions
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
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundSecondary)
                        .overlay {
                            Image(systemName: "photo")
                                .font(isIPad ? .largeTitle : .title)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityLabel(LocalizedStrings.accessibilityCategoryImage)
                }
                .aspectRatio(imageAspectRatio, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(spacing: isIPad ? 6 : 4) {
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
            HStack(spacing: 16) {
                // SF Symbol heart icon
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                    .frame(width: 80, height: 80)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.1))
                    }
                
                VStack(alignment: .leading, spacing: 8) {
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
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 8,
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
