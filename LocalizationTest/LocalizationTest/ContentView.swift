//
//  ContentView.swift
//  LocalizationTest
//
//  Created by Gerard on 8/26/24.
//

import SwiftUI

struct ContentView: View {
    @State var welcomeString = Constants.Strings.welcome_message
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(welcomeString)
//            Text(Constants.Strings.welcome_messageRx)
//            Text(Constants.Strings.welcome_messageSUI)
            
            Button("Vietnam") {
                // This implementation is originated from Native UIKit
                // Can modify the implementation for RxSwift / SwiftUI
                LocalizationManager.shared.updateCurrentLanguage(.vi) { isSuccess in
                    if isSuccess {
                        welcomeString = Constants.Strings.welcome_message
                    }
                }
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.red)
            .padding(.top,10)
            
            
            Button("English") {
                LocalizationManager.shared.updateCurrentLanguage(.en) { isSuccess in
                    if isSuccess {
                        welcomeString = Constants.Strings.welcome_message
                    }
                }
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.blue)
            .padding(.top,10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
