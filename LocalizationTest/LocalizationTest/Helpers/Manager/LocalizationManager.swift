//
//  LocalizationManager.swift
//  LocalizationTest
//
//  Created by Gerard on 8/26/24.
//

import Foundation

final class LocalizationManager {
    
    static let shared = LocalizationManager()
    
    /// detect current iphone language settings
    /// if language not included in the Language enum, will default to english
    /// if key not found in local bundle, will default to english
    private(set) lazy var language: Language = {
        guard let languageName = UserDefaults.standard.string(forKey: Constants.UserDefaultKey.language) else {
            return .en
        }
        
        return Language.init(with: languageName) ?? .en
    }() {
        willSet { locale = Locale(identifier: newValue.lprojLanguageCode()) }
    }
    
    private(set) lazy var locale: Locale = {
        Locale(identifier: language.lprojLanguageCode())
    }()
    
    private lazy var bundle: Bundle = {
        guard let url = Bundle.main.url(forResource: language.lprojLanguageCode(), withExtension: "lproj"),
              let bundle = Bundle(url: url)
        else {
            return Bundle.main
        }
        
        return bundle
    }()
    
    func localize(key: String) -> String {
        let localizedString = bundle.localizedString(forKey: key, value: "", table: "Localizable")
        
        // default lang bundle if key not found
        guard key != localizedString else {
            return getDefaultString(for: key)
        }
        
        return localizedString
    }
    
    func retriveCurrentLanguage() -> Language {
        return language
    }
    
    
    // when called and succeed will change the language ONLY
    // problem: the UI need to be reloaded to update the language strings
    // possible solution: Async, RxSwift, or handle using SwiftUI. EnvinronmentState / RxSwift equivalent
    func updateCurrentLanguage(_ language: Language) {
        /// Config Language
        guard let newLanguage = Language.init(with: language.nameOnPicker) else {
            return
        }
        
        self.language = newLanguage
        UserDefaults.standard.setValue(language.nameOnPicker, forKey: Constants.UserDefaultKey.language)
        
        /// Config new bundle for localizable
        guard let url = Bundle.main.url(forResource: language.lprojLanguageCode(), withExtension: "lproj"),
              let bundle = Bundle(url: url)
        else {
            self.bundle = Bundle.main
            return
        }
        
        /// update bundle
        self.bundle = bundle
        /// post notification that language had changed
        /// handle the observers if needed
        NotificationCenter.default.post(name: .languageChanged, object: self.language)
    }
    
    // override updateCurrentLanguage
    func updateCurrentLanguage(_ language: Language, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let newLanguage = Language.init(with: language.nameOnPicker) else {
            completion(false)
            return
        }
        
        self.language = newLanguage
        UserDefaults.standard.setValue(language.nameOnPicker, forKey: Constants.UserDefaultKey.language)
        
        guard let url = Bundle.main.url(forResource: language.lprojLanguageCode(), withExtension: "lproj"),
              let bundle = Bundle(url: url)
        else {
            self.bundle = Bundle.main
            completion(false)
            return
        }
        
        self.bundle = bundle
        NotificationCenter.default.post(name: .languageChanged, object: self.language)
        completion(true)
    }
    
    private func getDefaultString(for key:String) -> String {
        guard let url = Bundle.main.url(forResource: language.lprojLanguageCode(), withExtension: "lproj"),
              let bundle = Bundle(url: url)
        else {
            return ""
        }
        
        let defaultString = bundle.localizedString(forKey: key, value: "", table: "Localizable")
        return defaultString
    }
    
}

//MARK: extension
extension LocalizationManager {
    enum Language: String {
        case en = "en" /// english
        case vi = "vi" /// vietnam
       
        /// init based on device language
        init?() {
            if let languageCode = Locale.current.language.languageCode?.identifier {
                switch languageCode {
                case _ where languageCode.contains("en"):
                    self = Language.en
                case _ where languageCode.contains("vi"):
                    self = Language.vi
                default:
                    return nil
                }
            } else {
                return nil
            }
        }
        
        /// for selecting language on app
        init?(with languageName: String) {
            switch languageName {
            case Constants.Name.english:
                self = Self.en
            case Constants.Name.vietnam:
                self = Self.vi
            default:
                return nil
            }
        }
        
        var nameOnPicker: String {
            switch self {
            case .en:
                return Constants.Name.english
            case .vi:
                return Constants.Name.vietnam
            }
        }
        
        func lprojLanguageCode() -> String {
            switch self {
            case .en:
                return "en"
            case .vi:
                return "vi"
            }
        }
    }
}

// MARK: extension.Language
extension LocalizationManager.Language {
    enum Constants {
        enum Name {
            static let english = "English"
            static let vietnam = "Vietnam"
        }
    }
}
