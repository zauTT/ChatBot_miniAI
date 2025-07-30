//
//  ConversationStorage.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 30.07.25.
//

import Foundation

class ConversationStorage {
    private let key = "saved_conversations"
    
    func save(_ conversation: Conversation) {
        var all = fetchAll()
        all.insert(conversation, at: 0)
        if let data = try? JSONEncoder().encode(all) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func fetchAll() -> [Conversation] {
         guard let data = UserDefaults.standard.data(forKey: key),
               let conversations = try? JSONDecoder().decode([Conversation].self, from: data) else {
             return []
         }
         return conversations
     }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
