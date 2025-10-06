//
//  CategoryListView.swift
//  Whisked
//
//  Created by GitHub Copilot on 10/5/25.
//

import SwiftUI
import ThemeKit
import PersistenceKit
import Combine

/// View displaying available meal categories for user selection
struct CategoryListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: CategoryListViewModel
    private let coordinator: WhiskedMainCoordinator

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
    
    init(coordinator: WhiskedMainCoordinator, viewModel: CategoryListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle("Meal Categories")
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

            Text("No Categories Available")
                .font(.title2)
                .foregroundStyle(.primary)

            Text("No meal categories could be loaded at this time.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
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
    }
    
    private func loadedView(categories: [MealCategory]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Favorites card - always show at the top
                FavoritesCard(
                    favoritesCount: viewModel.favoritesCount,
                    onTap: {
                        coordinator.showFavorites()
                    }
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 0.8).combined(with: .opacity)
                ))
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0),
                    value: viewModel.loadingState
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
                                coordinator.showMealsByCategory(category)
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
                            .delay(Double(index) * 0.1),
                            value: viewModel.loadingState
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
            
            Text("Unable to Load Categories")
                .font(.title2)
                .foregroundStyle(.primary)
            
            Text("Please check your internet connection and try again.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                Task {
                    await viewModel.load()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
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
        isIPad ? 4/3 : 3/2  // Slightly taller on iPad for better proportions
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
                    Text("Favorites")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(favoritesCount == 0 ? "No favorite meals yet" : "\(favoritesCount) favorite meal\(favoritesCount == 1 ? "" : "s")")
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
    }
}

// MARK: - Previews

#Preview("CategoryListView - Loaded") {
    let coordinator = WhiskedMainCoordinator(networkService: MockNetworkService.success())
    coordinator.createCategoryListView()
}

#Preview("CategoryListView - Loading") {
    let coordinator = WhiskedMainCoordinator(networkService: MockNetworkService.slowNetwork())
    coordinator.createCategoryListView()
}

#Preview("CategoryListView - Error") {
    let coordinator = WhiskedMainCoordinator(networkService: MockNetworkService.networkError())
    coordinator.createCategoryListView()
}
