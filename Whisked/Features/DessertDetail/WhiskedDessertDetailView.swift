//
//  WhiskedDessertDetailView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI

/// View displaying detailed information about a specific dessert
struct WhiskedDessertDetailView: View {
    
    // MARK: - Properties
    
    private let coordinator: WhiskedMainCoordinator
    @State private var viewModel: DessertDetailViewModel
    
    // MARK: - Initialization
    
    init(mealID: String, coordinator: WhiskedMainCoordinator, viewModel: DessertDetailViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .navigationTitle("Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                if viewModel.state.mealDetail == nil {
                    await viewModel.fetchMealDetails()
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
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading recipe details...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func detailScrollView(mealDetail: MealDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Meal Header
                mealHeaderView(mealDetail: mealDetail)
                
                // Ingredients Section
                ingredientsSection(ingredients: mealDetail.ingredients)
                
                // Instructions Section
                instructionsSection(instructions: mealDetail.instructions)
            }
            .padding()
        }
    }
    
    private func mealHeaderView(mealDetail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Meal Image
            AsyncImage(url: URL(string: mealDetail.strMealThumb)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
            }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Meal Name
            Text(mealDetail.strMeal)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
    
    private func ingredientsSection(ingredients: [Ingredient]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ingredients")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ingredients) { ingredient in
                    ingredientCard(ingredient: ingredient)
                }
            }
        }
    }
    
    private func ingredientCard(ingredient: Ingredient) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ingredient.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Text(ingredient.measure)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func instructionsSection(instructions: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(instructions)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var errorView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 100)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    VStack(spacing: 8) {
                        Text("Recipe Not Available")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(viewModel.state.errorMessage ?? "Something went wrong")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button("Try Again") {
                        Task {
                            await viewModel.retry()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer(minLength: 100)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height - 100)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

// MARK: - Previews

#Preview("Success State") {
    NavigationStack {
        WhiskedDessertDetailView(
            mealID: "52893",
            coordinator: WhiskedMainCoordinator(),
            viewModel: DessertDetailViewModel(
                mealID: "52893",
                networkService: MockNetworkService.success()
            )
        )
    }
}

#Preview("Error State") {
    NavigationStack {
        WhiskedDessertDetailView(
            mealID: "invalid",
            coordinator: WhiskedMainCoordinator(),
            viewModel: DessertDetailViewModel(
                mealID: "invalid",
                networkService: MockNetworkService.notFoundError()
            )
        )
    }
}
