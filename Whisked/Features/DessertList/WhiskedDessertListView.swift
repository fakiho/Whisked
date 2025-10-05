//
//  WhiskedDessertListView.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI

/// View displaying the list of desserts
struct WhiskedDessertListView: View {
    
    // MARK: - Properties
    
    @State private var coordinator: WhiskedMainCoordinator
    @State private var viewModel: DessertListViewModel
    
    // MARK: - Initialization
    
    init(coordinator: WhiskedMainCoordinator, viewModel: DessertListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            contentView
                .navigationTitle("Desserts")
                .navigationBarTitleDisplayMode(.large)
                .refreshable {
                    await viewModel.refresh()
                }
                .task {
                    if viewModel.desserts.isEmpty {
                        await viewModel.fetchDesserts()
                    }
                }
                .navigationDestination(for: WhiskedMainCoordinator.Destination.self) { destination in
                    coordinator.view(for: destination)
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
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading delicious desserts...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var dessertListView: some View {
        List(viewModel.desserts) { dessert in
            DessertRowView(meal: dessert) {
                coordinator.showDessertDetail(dessertId: dessert.idMeal)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
    }
    
    private var errorView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 100)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
                VStack(spacing: 8) {
                    Text("Oops!")
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
            .frame(minHeight: UIScreen.main.bounds.height - 200)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

// MARK: - DessertRowView

private struct DessertRowView: View {
    let meal: Meal
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.strMeal)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text("Tap to view recipe")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Success State") {
    WhiskedDessertListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: DessertListViewModel(networkService: MockNetworkService.success())
    )
}

#Preview("Loading State") {
    let viewModel = DessertListViewModel(networkService: MockNetworkService.success())
    // Note: In a real preview, we'd set the state to loading manually
    return WhiskedDessertListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: viewModel
    )
}

#Preview("Error State") {
    WhiskedDessertListView(
        coordinator: WhiskedMainCoordinator(),
        viewModel: DessertListViewModel(networkService: MockNetworkService.networkError())
    )
}