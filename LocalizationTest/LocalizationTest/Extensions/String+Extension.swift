//
//  String+Extension.swift
//  LocalizationTest
//
//  Created by Gerard on 8/26/24.
//

import Foundation

extension String {
    func localize() -> String {
        return LocalizationManager.shared.localize(key: self)
    }
}
