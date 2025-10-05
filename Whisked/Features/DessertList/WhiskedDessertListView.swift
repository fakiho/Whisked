//
//  WhiskedDessertListView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit

/// View displaying the list of desserts with advanced animations and theming
struct WhiskedDessertListView: View {
    
    // MARK: - Properties
    
    @State private var coordinator: WhiskedMainCoordinator
    @State private var viewModel: DessertListViewModel
    
    // Hero animation namespace
    let heroAnimationNamespace: Namespace.ID
    
    // Animation state
    @State private var hasAppeared = false
    
    // MARK: - Initialization
    
    init(
        coordinator: WhiskedMainCoordinator, 
        viewModel: DessertListViewModel,
        heroAnimationNamespace: Namespace.ID
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.heroAnimationNamespace = heroAnimationNamespace
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            contentView
                .navigationTitle("Desserts")
                .navigationBarTitleDisplayMode(.large)
                .background(Color.backgroundPrimary)
                .refreshable {
                    await viewModel.refresh()
                }
                .task {
                    if viewModel.desserts.isEmpty {
                        await viewModel.fetchDesserts()
                    }
                }
                .navigationDestination(for: WhiskedMainCoordinator.Destination.self) { destination in
                    coordinator.view(for: destination, heroAnimationNamespace: heroAnimationNamespace)
                }
                .accessibilityRotor("Desserts") {
                    ForEach(viewModel.desserts) { dessert in
                        AccessibilityRotorEntry(dessert.strMeal, id: dessert.id) {
                            // This will focus on the specific dessert
                        }
                    }
                }
        }
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .success:
            dessertListView
        case .error:
            errorView
        }
    }
    
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large.value) {
                // Hero section with shimmer
                VStack(spacing: Theme.Spacing.medium.value) {
                    Text("Loading delicious desserts...")
                        .themeHeadline()
                        .foregroundColor(.textSecondary)
                        .themePadding(.top, .extraLarge)
                    
                    Text("Preparing your sweet treats")
                        .themeBody()
                        .foregroundColor(.textSecondary)
                }
                .themePadding(.horizontal, .large)
                
                // Shimmer grid
                ShimmerDessertGrid(itemCount: 6)
                    .themePadding(.horizontal, .medium)
            }
        }
        .background(Color.backgroundPrimary)
        .accessibilityLabel("Loading desserts")
        .accessibilityHint("Please wait while we fetch delicious dessert recipes")
    }
    
    private var dessertListView: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium.value) {
                // Header section
                VStack(spacing: Theme.Spacing.small.value) {
                    Text("Sweet Treats")
                        .themeDisplayLarge()
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Discover \(viewModel.desserts.count) delicious dessert recipes")
                        .themeBody()
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .themePadding(.horizontal, .large)
                .themePadding(.top, .medium)
                
                // Dessert cards with staggered animation
                ForEach(Array(viewModel.desserts.enumerated()), id: \.element.id) { index, dessert in
                    DessertCard(
                        meal: dessert,
                        heroAnimationNamespace: heroAnimationNamespace,
                        onTap: {
                            coordinator.showDessertDetail(dessertId: dessert.idMeal)
                        }
                    )
                    .opacity(hasAppeared ? 1 : 0)
                    .scaleEffect(hasAppeared ? 1 : 0.8)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: hasAppeared
                    )
                }
                .themePadding(.horizontal, .medium)
                
                // Bottom spacing
                Spacer(minLength: Theme.Spacing.large.value)
            }
        }
        .background(Color.backgroundPrimary)
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
            }
        }
        .accessibilityLabel("Dessert list")
        .accessibilityHint("Swipe up and down to browse dessert recipes")
    }
    
    private var errorView: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.extraLarge.value) {
                Spacer(minLength: 100)
                
                // Error icon with theme colors
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.warning)
                
                VStack(spacing: Theme.Spacing.medium.value) {
                    Text("Oops!")
                        .themeDisplayLarge()
                        .foregroundColor(.textPrimary)
                    
                    Text(viewModel.state.errorMessage ?? "Something went wrong while loading desserts")
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
                .themePadding(.horizontal, .large)
                
                Spacer(minLength: 100)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 600)
        }
        .background(Color.backgroundPrimary)
        .refreshable {
            await viewModel.refresh()
        }
        .accessibilityLabel("Error loading desserts")
        .accessibilityHint("Tap try again to reload the dessert list")
    }
}

// MARK: - DessertCard

private struct DessertCard: View {
    let meal: Meal
    let heroAnimationNamespace: Namespace.ID
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Theme.Spacing.medium.value) {
                // Hero animated image
                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .fill(Color.backgroundSecondary)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: Theme.IconSize.medium))
                                .foregroundColor(.textSecondary)
                        }
                        .shimmer(isLoading: true)
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                .matchedGeometryEffect(
                    id: "dessert-image-\(meal.idMeal)",
                    in: heroAnimationNamespace,
                    isSource: true  // List view is the source of the animation
                )
                
                VStack(alignment: .leading, spacing: Theme.Spacing.small.value) {
                    Text(meal.strMeal)
                        .themeHeadline()
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Tap to view recipe")
                        .themeCaption()
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 0)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: Theme.IconSize.small, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
            .themePadding(.all, .medium)
            .background(Color.backgroundSecondary)
            .cornerRadius(Theme.CornerRadius.large)
            .shadow(
                color: Color.black.opacity(0.05),
                radius: isPressed ? 2 : 8,
                x: 0,
                y: isPressed ? 1 : 4
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { isPressing in
            isPressed = isPressing
        } perform: {
            // Long press action if needed
        }
        .accessibilityLabel(meal.strMeal)
        .accessibilityHint("Double tap to view detailed recipe")
        .accessibilityAddTraits(.isButton)
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
    return WhiskedDessertListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: DessertListViewModel(networkService: MockNetworkService.success()),
        heroAnimationNamespace: heroNamespace
    )
}

#Preview("Loading State") {
    @Previewable @Namespace var heroNamespace
    let viewModel = DessertListViewModel(networkService: MockNetworkService.success())
    return WhiskedDessertListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: viewModel,
        heroAnimationNamespace: heroNamespace
    )
}

#Preview("Error State") {
    @Previewable @Namespace var heroNamespace
    return WhiskedDessertListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: DessertListViewModel(networkService: MockNetworkService.networkError()),
        heroAnimationNamespace: heroNamespace
    )
}
