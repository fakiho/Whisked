//
//  WhiskedMealListView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import ThemeKit
import NetworkKit

/// View displaying the list of meals for a category with advanced animations and theming
struct MealListView: View {

    // MARK: - Properties
    
    @State private var coordinator: WhiskedMainCoordinator
    @State private var viewModel: MealListViewModel
    
    // Animation state
    @State private var hasAppeared = false
    
    // Search state
    @State private var searchText = ""
    
    // Device and screen size detection for iPad support
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
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
            .searchable(text: $searchText, prompt: LocalizedStrings.mealsSearchPlaceholder)
            .accessibilityLabel(LocalizedStrings.accessibilitySearchBar)
            .accessibilityHint(LocalizedStrings.accessibilitySearchBarHint)
            .onChange(of: searchText) { _, newValue in
                viewModel.performDebouncedSearch(query: newValue)
            }
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                // Initial fetch - only happens once due to ViewModel logic
                if viewModel.meals.isEmpty && viewModel.state == .idle {
                    await viewModel.fetchAllMeals()
                }
            }
            .onAppear {
                // Refresh favorites when returning to this view
                Task {
                    await viewModel.refreshFavorites()
                }
            }
            .accessibilityRotor("Meals") {
                ForEach(viewModel.filteredMeals) { meal in
                    AccessibilityRotorEntry(meal.name, id: meal.id) {
                        // This will focus on the specific meal
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("\(viewModel.category.name) recipes")
            .accessibilityValue(LocalizedStrings.accessibilityRecipeCount(viewModel.filteredMeals.count))
    }
    
    // MARK: - Responsive Design Helpers
    
    /// Determines if we're running on iPad or large screen
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    /// Determines if we're in landscape orientation
    private var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }
    
    /// Adaptive icon size based on device
    private var adaptiveIconSize: CGFloat {
        if isIPad {
            return Theme.IconSize.extraLarge
        } else if isLandscape {
            return Theme.IconSize.large
        } else {
            return Theme.IconSize.extraLarge
        }
    }
    
    /// Adaptive minimum height for empty states
    private var adaptiveMinHeight: CGFloat {
        if isIPad {
            return isLandscape ? 500 : 700
        } else {
            return isLandscape ? 400 : 600
        }
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case .loaded, .finished, .loadingMore:
            mealListView
        case .error:
            errorView
        }
    }
    
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large.value) {
                // Hero section with shimmer - only shown during initial fetch
                VStack(spacing: Theme.Spacing.medium.value) {
                    Text(LocalizedStrings.mealsLoading(category: viewModel.category.name))
                        .font(isIPad ? .themeDisplayLarge() : .themeHeadline())
                        .foregroundColor(.textSecondary)
                        .themePadding(.top, isIPad ? .huge : .extraLarge)
                    
                    Text(LocalizedStrings.mealsLoadingDescription)
                        .font(isIPad ? .themeHeadline() : .themeBody())
                        .foregroundColor(.textSecondary)
                }
                .themePadding(.horizontal, isIPad ? .extraLarge : .large)
                
                // Shimmer grid - represents loading state for initial fetch only
                ShimmerMealGrid(itemCount: isIPad ? 9 : 6)
                    .themePadding(.horizontal, isIPad ? .extraLarge : .medium)
            }
        }
        .background(Color.backgroundPrimary)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityLoadingMeals(category: viewModel.category.name))
        .accessibilityHint(LocalizedStrings.accessibilityLoadingHint)
        .accessibilityAddTraits(.updatesFrequently)
    }
    
    private var mealListView: some View {
        ScrollView {
            if viewModel.filteredMeals.isEmpty && viewModel.isSearchActive {
                emptySearchView
            } else {
                mealListContent
            }
        }
        .background(Color.backgroundPrimary)
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(LocalizedStrings.accessibilityMealList)
        .accessibilityHint(LocalizedStrings.accessibilityMealListHint)
        .accessibilityValue("Showing \(viewModel.filteredMeals.count) recipes")
    }
    
    private var mealListContent: some View {
        LazyVStack(spacing: isIPad ? Theme.Spacing.large.value : Theme.Spacing.medium.value) {
            // Meal cards with efficient pagination
            ForEach(Array(viewModel.filteredMeals.enumerated()), id: \.element.id) { index, meal in
                MealCard(
                    meal: meal,
                    isFavorite: viewModel.isFavorite(mealID: meal.id),
                    isIPad: isIPad,
                    onTap: {
                        coordinator.showMealDetail(mealId: meal.id)
                    }
                )
                .opacity(hasAppeared ? 1 : 0)
                .scaleEffect(hasAppeared ? 1 : 0.8)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(Double(index) * (isIPad ? 0.03 : 0.05)),
                    value: hasAppeared
                )
                .themePadding(.horizontal, isIPad ? .extraLarge : .medium)
                .onAppear {
                    // Only trigger pagination on specific threshold items for efficiency
                    if viewModel.shouldTriggerPagination(for: index) {
                        viewModel.loadNextPage()
                    }
                }
                .id(meal.id)
            }
            
            // Loading more indicator and pagination trigger
            if viewModel.state.isLoadingMore {
                loadingMoreView
            } else if !viewModel.state.isFinished && !viewModel.filteredMeals.isEmpty {
                // Invisible pagination trigger - more efficient than onAppear on every card
                paginationTrigger
            }
            
            bottomSpacing
        }
    }
    
    /// Invisible view that triggers pagination when it appears
    /// More efficient than checking every card
    private var paginationTrigger: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 1)
            .onAppear {
                // This will only trigger when user scrolls close to the bottom
                if !viewModel.state.isLoadingMore && !viewModel.state.isFinished {
                    viewModel.loadNextPage()
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(LocalizedStrings.accessibilityPaginationTrigger)
            .accessibilityHint(LocalizedStrings.accessibilityPaginationHint)
            .accessibilityAddTraits(.updatesFrequently)
    }
    
    /// Loading more indicator shown at the bottom when paginating
    private var loadingMoreView: some View {
        HStack(spacing: isIPad ? Theme.Spacing.large.value : Theme.Spacing.medium.value) {
            ProgressView()
                .scaleEffect(isIPad ? 1.0 : 0.8)
                .tint(.textSecondary)
            
            Text(LocalizedStrings.mealsLoadingMore)
                .font(isIPad ? .themeBody() : .themeCaption())
                .foregroundColor(.textSecondary)
        }
        .themePadding(.vertical, isIPad ? .extraLarge : .large)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.mealsLoadingMore)
        .accessibilityAddTraits(.updatesFrequently)
    }
    
    private var bottomSpacing: some View {
        Spacer(minLength: isIPad ? Theme.Spacing.extraLarge.value : Theme.Spacing.large.value)
    }
    
    /// Empty state view shown when search returns no results
    private var emptySearchView: some View {
        VStack(spacing: isIPad ? Theme.Spacing.huge.value : Theme.Spacing.extraLarge.value) {
            Spacer(minLength: isIPad ? 120 : 100)
            
            // Search icon with theme colors and adaptive sizing
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: adaptiveIconSize))
                .foregroundColor(.textSecondary)
                .opacity(0.6)
            
            VStack(spacing: isIPad ? Theme.Spacing.large.value : Theme.Spacing.medium.value) {
                Text(LocalizedStrings.mealsEmptySearchTitle)
                    .font(isIPad ? .themeDisplayLarge() : .themeDisplayMedium())
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                if !searchText.isEmpty {
                    Text(LocalizedStrings.mealsEmptySearchQuery(query: searchText))
                        .font(isIPad ? .themeDisplayMedium() : .themeHeadline())
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .themePadding(.horizontal, isIPad ? .extraLarge : .large)
                }
                
                Text(LocalizedStrings.mealsEmptySearchDescription)
                    .font(isIPad ? .themeHeadline() : .themeBody())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .themePadding(.horizontal, isIPad ? .extraLarge : .large)
                
                Text(LocalizedStrings.mealsEmptySearchSuggestion)
                    .font(isIPad ? .themeBody() : .themeCaption())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .themePadding(.horizontal, isIPad ? .extraLarge : .large)
                    .themePadding(.top, isIPad ? .medium : .small)
            }
            
            Spacer(minLength: isIPad ? 120 : 100)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: adaptiveMinHeight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(LocalizedStrings.accessibilityEmptySearch)
        .accessibilityHint(LocalizedStrings.accessibilityEmptySearchHint)
        .accessibilityValue(searchText.isEmpty ? "" : LocalizedStrings.uiNoResultsFor(query: searchText))
    }
    
    private var errorView: some View {
        ScrollView {
            VStack(spacing: isIPad ? Theme.Spacing.huge.value : Theme.Spacing.extraLarge.value) {
                Spacer(minLength: isIPad ? 120 : 100)
                
                // Error icon with theme colors and adaptive sizing
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: isIPad ? Theme.IconSize.extraLarge : Theme.IconSize.large))
                    .foregroundColor(.warning)
                
                VStack(spacing: isIPad ? Theme.Spacing.large.value : Theme.Spacing.medium.value) {
                    Text(LocalizedStrings.mealsErrorTitle)
                        .font(isIPad ? .themeDisplayLarge() : .themeDisplayMedium())
                        .foregroundColor(.textPrimary)
                    
                    Text(viewModel.state.errorMessage ?? LocalizedStrings.mealsErrorDefault)
                        .font(isIPad ? .themeHeadline() : .themeBody())
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .themePadding(.horizontal, isIPad ? .extraLarge : .large)
                }
                
                Button(LocalizedStrings.mealsTryAgain) {
                    Task {
                        await viewModel.retry()
                    }
                }
                .themeButton(isIPad: isIPad)
                .themePadding(.horizontal, isIPad ? .extraLarge : .large)
                
                Spacer(minLength: isIPad ? 120 : 100)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: adaptiveMinHeight)
        }
        .background(Color.backgroundPrimary)
        .refreshable {
            await viewModel.refresh()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(LocalizedStrings.accessibilityErrorLoading)
        .accessibilityHint(LocalizedStrings.accessibilityRetryHint)
    }
    
    // MARK: - Search Methods
    // Search logic is now properly handled in the ViewModel
}

// MARK: - MealCard

private struct MealCard: View {
    let meal: Meal
    let isFavorite: Bool
    let isIPad: Bool
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(LocalizedStrings.accessibilityMealCard), \(meal.name)")
        .accessibilityHint(LocalizedStrings.accessibilityMealCardHint)
        .accessibilityValue(isFavorite ? LocalizedStrings.accessibilityFavorited : "")
        .accessibilityAddTraits(.isButton)
    }
    
    private var cardContent: some View {
        HStack(spacing: isIPad ? Theme.Spacing.large.value : Theme.Spacing.medium.value) {
            cardImage
            cardText
            Spacer()
            favoriteIcon
            chevronIcon
        }
        .themePadding(.all, isIPad ? .large : .medium)
        .background(Color.backgroundSecondary)
        .themeCornerRadius(isIPad ? Theme.CornerRadius.extraLarge : Theme.CornerRadius.large)
        .shadow(
            color: Color.black.opacity(0.05),
            radius: isPressed ? (isIPad ? 4 : 2) : (isIPad ? 12 : 8),
            x: 0,
            y: isPressed ? (isIPad ? 2 : 1) : (isIPad ? 6 : 4)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    private var cardImage: some View {
        AsyncImage(url: URL(string: meal.thumbnailURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            RoundedRectangle(cornerRadius: isIPad ? Theme.CornerRadius.large : Theme.CornerRadius.medium)
                .fill(Color.backgroundSecondary)
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: isIPad ? Theme.IconSize.large : Theme.IconSize.medium))
                        .foregroundColor(.textSecondary)
                }
        }
        .frame(width: isIPad ? 100 : 80, height: isIPad ? 100 : 80)
        .clipShape(RoundedRectangle(cornerRadius: isIPad ? Theme.CornerRadius.large : Theme.CornerRadius.medium))
        .accessibilityLabel(LocalizedStrings.accessibilityMealImage)
        .accessibilityHidden(true) // Image is decorative, meal name is already in card label
    }
    
    private var cardText: some View {
        VStack(alignment: .leading, spacing: isIPad ? Theme.Spacing.medium.value : Theme.Spacing.small.value) {
            Text(meal.name)
                .font(isIPad ? .themeDisplayMedium() : .themeHeadline())
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(isIPad ? 3 : 2)
            
            Text(LocalizedStrings.mealsTapToView)
                .font(isIPad ? .themeBody() : .themeCaption())
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
    }
    
    private var favoriteIcon: some View {
        Group {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: isIPad ? Theme.IconSize.medium : Theme.IconSize.small, weight: .medium))
                    .foregroundColor(.error) // Using red color for favorite
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                    .accessibilityLabel(LocalizedStrings.accessibilityFavorited)
            } else {
                // Empty space to maintain layout consistency
                Image(systemName: "heart")
                    .font(.system(size: isIPad ? Theme.IconSize.medium : Theme.IconSize.small, weight: .medium))
                    .foregroundColor(.clear)
                    .accessibilityHidden(true)
            }
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: isIPad ? Theme.IconSize.medium : Theme.IconSize.small, weight: .medium))
            .foregroundColor(.textSecondary)
            .scaleEffect(isPressed ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

// MARK: - Button Style Extension

private extension Button where Label == Text {
    func themeButton(isIPad: Bool = false) -> some View {
        self
            .font(isIPad ? .themeDisplayMedium() : .themeButton())
            .foregroundColor(.white)
            .themePadding(.horizontal, isIPad ? .huge : .extraLarge)
            .themePadding(.vertical, isIPad ? .large : .medium)
            .background(Color.accent)
            .themeCornerRadius(isIPad ? Theme.CornerRadius.large : Theme.CornerRadius.medium)
            .shadow(
                color: Color.accent.opacity(0.3), 
                radius: isIPad ? 12 : 8, 
                x: 0, 
                y: isIPad ? 6 : 4
            )
    }
}
