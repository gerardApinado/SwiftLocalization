//
//  Constants.swift
//  LocalizationTest
//
//  Created by Gerard on 8/26/24.
//

import Foundation

struct Constants {
    
    struct UserDefaultKey {
        static let language = "user_defined_language"
    }
    
    struct Strings {
        static var welcome_message: String { "welcome_message".localize() }
//        static var welcome_messageRx: String { "welcome_messageRx".localize() }
//        static var welcome_messageSUI: String { "welcome_messageSUI".localize() }
    }
}
