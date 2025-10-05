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
    
    let dessertId: String
    private let coordinator: WhiskedMainCoordinator
    
    // MARK: - Initialization
    
    init(dessertId: String, coordinator: WhiskedMainCoordinator) {
        self.dessertId = dessertId
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Whisked Dessert Detail")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Dessert ID: \(dessertId)")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Detail View Placeholder")
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Dessert Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}