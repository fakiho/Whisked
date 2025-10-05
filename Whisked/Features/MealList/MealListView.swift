//
//  WhiskedMealListView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit

/// View displaying the list of meals for a category with advanced animations and theming
struct MealListView: View {

    // MARK: - Properties
    
    @State private var coordinator: WhiskedMainCoordinator
    @State private var viewModel: MealListViewModel
    
    // Animation state
    @State private var hasAppeared = false
    
    // MARK: - Initialization
    
    init(
        coordinator: WhiskedMainCoordinator, 
        viewModel: MealListViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle(viewModel.category.name)
            .navigationBarTitleDisplayMode(.large)
            .background(Color.backgroundPrimary)
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                if viewModel.meals.isEmpty {
                    await viewModel.fetchMeals()
                }
            }
            .accessibilityRotor("Meals") {
                ForEach(viewModel.meals) { meal in
                    AccessibilityRotorEntry(meal.strMeal, id: meal.id) {
                        // This will focus on the specific meal
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
            mealListView
        case .error:
            errorView
        }
    }
    
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large.value) {
                // Hero section with shimmer
                VStack(spacing: Theme.Spacing.medium.value) {
                    Text("Cooking delicious meals...")
                        .themeHeadline()
                        .foregroundColor(.textSecondary)
                        .themePadding(.top, .extraLarge)
                    
                    Text("Preparing your meals")
                        .themeBody()
                        .foregroundColor(.textSecondary)
                }
                .themePadding(.horizontal, .large)
                
                // Shimmer grid
                ShimmerMealGrid(itemCount: 6)
                    .themePadding(.horizontal, .medium)
            }
        }
        .background(Color.backgroundPrimary)
        .accessibilityLabel("Loading meals")
        .accessibilityHint("Please wait while we fetch delicious meal recipes")
    }
    
    private var mealListView: some View {
        ScrollView {
            mealListContent
        }
        .background(Color.backgroundPrimary)
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
            }
        }
        .accessibilityLabel("Meal list")
        .accessibilityHint("Swipe up and down to browse meal recipes")
    }
    
    private var mealListContent: some View {
        LazyVStack(spacing: Theme.Spacing.medium.value) {
            headerSection
            mealCardsSection
            bottomSpacing
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: Theme.Spacing.small.value) {
            Text("Discover \(viewModel.meals.count) delicious meal recipes")
                .themeBody()
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .themePadding(.horizontal, .large)
        .themePadding(.top, .medium)
    }
    
    private var mealCardsSection: some View {
        VStack(spacing: Theme.Spacing.medium.value) {
            ForEach(Array(viewModel.meals.enumerated()), id: \.element.id) { index, meal in
                MealCard(
                    meal: meal,
                    onTap: {
                        coordinator.showMealDetail(mealId: meal.idMeal)
                    }
                )
                .opacity(hasAppeared ? 1 : 0)
                .scaleEffect(hasAppeared ? 1 : 0.8)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(Double(index) * 0.1),
                    value: hasAppeared
                )
                .onAppear {
                    viewModel.checkForLoadMore(meal: meal)
                }
            }
            .padding(.horizontal, Theme.Spacing.medium.value)
            
            // Pagination controls
            if viewModel.hasMorePages {
                if viewModel.isLoadingMore {
                    HStack(spacing: Theme.Spacing.medium.value) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                            .scaleEffect(0.8)
                        Text("Loading more meals...")
                            .themeCaption()
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.all, Theme.Spacing.large.value)
                } else {
                    Button("Load More Meals") {
                        viewModel.loadMoreMeals()
                    }
                    .themeButton()
                    .padding(.horizontal, Theme.Spacing.large.value)
                    .padding(.vertical, Theme.Spacing.medium.value)
                }
            }
        }
    }
    
    private var bottomSpacing: some View {
        Spacer(minLength: Theme.Spacing.large.value)
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
                    
                    Text(viewModel.state.errorMessage ?? "Something went wrong while loading meals")
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
        .accessibilityLabel("Error loading meals")
        .accessibilityHint("Tap try again to reload the meal list")
    }
}

// MARK: - MealCard

private struct MealCard: View {
    let meal: Meal
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            cardContent
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
    
    private var cardContent: some View {
        HStack(spacing: Theme.Spacing.medium.value) {
            cardImage
            cardText
            Spacer()
            chevronIcon
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
    
    private var cardImage: some View {
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
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
    }
    
    private var cardText: some View {
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
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: Theme.IconSize.small, weight: .medium))
            .foregroundColor(.textSecondary)
            .scaleEffect(isPressed ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
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
    MealListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: MealListViewModel(networkService: MockNetworkService.success(), category: .dessert)
    )
}

#Preview("Loading State") {
    @Previewable @Namespace var heroNamespace
    let viewModel = MealListViewModel(networkService: MockNetworkService.success(), category: .dessert)
    MealListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: viewModel
    )
}

#Preview("Error State") {
    @Previewable @Namespace var heroNamespace
    MealListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: MealListViewModel(networkService: MockNetworkService.networkError(), category: .dessert)
    )
}
