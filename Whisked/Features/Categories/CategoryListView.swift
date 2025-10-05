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
    private let coordinator: WhiskedMainCoordinator
    
    // MARK: - Initialization
    
    init(coordinator: WhiskedMainCoordinator, networkService: NetworkServiceProtocol = NetworkService()) {
        self._viewModel = StateObject(wrappedValue: CategoryListViewModel(networkService: networkService))
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle("Meal Categories")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadCategories()
            }
            .refreshable {
                await viewModel.refreshCategories()
            }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.loadingState {
        case .idle:
            VStack {
                ProgressView("Loading categories...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loading:
            loadingView
            
        case .loaded(let categories):
            if viewModel.displayedCategories.isEmpty {
                if viewModel.isLoadingMore {
                    // Show shimmer while loading first page after categories are fetched
                    loadingView
                } else {
                    // Show empty state only if no categories at all
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
            } else {
                loadedView(categories: categories)
            }
            
        case .failed(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ForEach(0..<6, id: \.self) { _ in
                CategoryCardShimmerView()
            }
        }
        .padding()
    }
    
    private func loadedView(categories: [MealCategory]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.displayedCategories.enumerated()), id: \.element.id) { index, category in
                    CategoryCard(
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
                    .onAppear {
                        viewModel.checkForLoadMore(category: category)
                    }
                }
                
                // Load more indicator
                if viewModel.hasMorePages {
                    if viewModel.isLoadingMore {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                            Text("Loading more categories...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    } else {
                        Button("Load More") {
                            viewModel.loadNextPage()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                    }
                }
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
                    await viewModel.loadCategories()
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

// MARK: - Previews

#Preview("CategoryListView - Loaded") {
    let coordinator = WhiskedMainCoordinator(networkService: MockNetworkService.success())
    CategoryListView(coordinator: coordinator, networkService: MockNetworkService.success())
}

#Preview("CategoryListView - Loading") {
    let coordinator = WhiskedMainCoordinator(networkService: MockNetworkService.slowNetwork())
    CategoryListView(coordinator: coordinator, networkService: MockNetworkService.slowNetwork())
}

#Preview("CategoryListView - Error") {
    let coordinator = WhiskedMainCoordinator(networkService: MockNetworkService.networkError())
    CategoryListView(coordinator: coordinator, networkService: MockNetworkService.networkError())
}