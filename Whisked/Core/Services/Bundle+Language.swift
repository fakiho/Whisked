//
//  Bundle+Language.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation

extension Bundle {
    private static var bundle: Bundle!
    
    static func setLanguage(language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        bundle = path != nil ? Bundle(path: path!) : Bundle.main
    }
    
    static func localizedBundle() -> Bundle {
        return bundle ?? Bundle.main
    }
}