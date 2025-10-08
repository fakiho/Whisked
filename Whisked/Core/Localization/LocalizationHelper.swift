//
//  LocalizationHelper.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation

extension String {
    func localized() -> String {
        return Bundle.localizedBundle().localizedString(forKey: self, value: nil, table: nil)
    }
}
