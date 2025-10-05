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
    
    // MARK: - Initialization
    
    init(coordinator: WhiskedMainCoordinator, persistenceService: PersistenceService?) {
        self._viewModel = StateObject(wrappedValue: FavoritesViewModel(persistenceService: persistenceService))
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle("Favorites")
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
                ProgressView("Loading favorites...")
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
            LazyVStack(spacing: 16) {
                ForEach(0..<6, id: \.self) { _ in
                    FavoriteMealCardShimmerView()
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Start exploring meals and save your favorites to see them here")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            Button("Explore Meals") {
                coordinator.popToRoot()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func loadedView(favorites: [FavoriteMeal]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(favorites.enumerated()), id: \.element.id) { index, favorite in
                    FavoriteMealCard(
                        favorite: favorite,
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
            .padding()
        }
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
    let onTap: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: favorite.strMealThumb)) { image in
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
                    Text(favorite.strMeal)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text("Saved \(favorite.dateSaved.formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(favorite.ingredients.count) ingredients")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: onRemove) {
                        Image(systemName: "heart.fill")
                            .font(.body)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Image(systemName: "chevron.right")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.tertiary)
                }
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

// MARK: - Favorite Meal Card Shimmer

private struct FavoriteMealCardShimmerView: View {
    
    var body: some View {
        HStack(spacing: 16) {
            ShimmerView()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
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
            
            VStack(spacing: 12) {
                ShimmerView()
                    .frame(width: 20, height: 20)
                
                ShimmerView()
                    .frame(width: 20, height: 20)
            }
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

#Preview("FavoritesView - Loaded") {
    let coordinator = WhiskedMainCoordinator()
    FavoritesView(coordinator: coordinator, persistenceService: nil)
}

#Preview("FavoritesView - Empty") {
    let coordinator = WhiskedMainCoordinator()
    FavoritesView(coordinator: coordinator, persistenceService: nil)
}