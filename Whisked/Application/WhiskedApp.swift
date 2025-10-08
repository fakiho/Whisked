//
//  WhiskedApp.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import SwiftUI
import SwiftData
import PersistenceKit

@main
struct WhiskedApp: App {
    
    // MARK: - Properties
    
    /// Main coordinator for managing navigation throughout the app
    @StateObject private var coordinator = WhiskedMainCoordinator()

    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.createCategoryListView()
                    .navigationDestination(for: WhiskedMainCoordinator.Destination.self) { destination in
                        coordinator.view(for: destination)
                    }
            }
            .environmentObject(LocalizableManager.shared)
        }
    }
}
