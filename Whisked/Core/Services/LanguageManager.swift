//
//  LanguageManager.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Language Types
enum LanguageTypes: String, CaseIterable {
    case english = "en"
    case french = "fr"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .french: return "Français"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .french: return "🇫🇷"
        }
    }
}

// MARK: - Localizable Manager
class LocalizableManager: ObservableObject {
    static let shared = LocalizableManager()
    
    @AppStorage("currentLanguage")
    private var storedLanguage: LanguageTypes = .english
    
    @Published var currentLanguage: LanguageTypes = .english {
        didSet {
            storedLanguage = currentLanguage
            Bundle.setLanguage(language: currentLanguage.rawValue)
        }
    }
    
    private init() {
        currentLanguage = storedLanguage
        Bundle.setLanguage(language: storedLanguage.rawValue)
    }
    
    func toggleLanguage() {
        currentLanguage = currentLanguage == .english ? .french : .english
    }
}
