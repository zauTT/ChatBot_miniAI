//
//  SecretsManager.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//

import Foundation

enum SecretsManager {
    static var openRouterApiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["OPENROUTER_API_KEY"] as? String else {
            fatalError("Missing OPENROUTER_API_KEY in Secrets.plist")
        }
        return key
    }
}
