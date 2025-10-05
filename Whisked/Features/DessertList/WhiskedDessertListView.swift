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
    
    // MARK: - Initialization
    
    init(coordinator: WhiskedMainCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack {
                Text("Whisked Desserts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Dessert List Placeholder")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Desserts")
            .navigationDestination(for: WhiskedMainCoordinator.Destination.self) { destination in
                coordinator.view(for: destination)
            }
        }
    }
}