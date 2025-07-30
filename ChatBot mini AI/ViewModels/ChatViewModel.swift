//
//  ChatViewModel.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//

import Foundation

class ChatViewModel {
    private let storage: ConversationStorage
    private let chatService = ChatService()
    private(set) var messages: [ChatMessage] = []

    var onUpdate: (() -> Void)?
    
    init(storage: ConversationStorage) {
        self.storage = storage
    }

    func send(_ text: String) {
        let userMessage = ChatMessage(text: text, sender: .user)
        messages.append(userMessage)
        onUpdate?()

        chatService.sendMessage(text) { [weak self] reply in
            guard let self = self, let reply = reply else { return }

            let aiMessage = ChatMessage(text: reply, sender: .ai)
            DispatchQueue.main.async {
                self.messages.append(aiMessage)
                self.onUpdate?()
            }
        }
    }
    
    func message(at index: Int) -> ChatMessage {
        return messages[index]
    }

    var messageCount: Int {
        return messages.count
    }
    
    func clearMessages() {
        messages.removeAll()
        onUpdate?()
    }
    
    func saveCurrentConversation() {
        guard !messages.isEmpty else { return }
        
        let conversation = Conversation(
            id: UUID(),
            date: Date(),
            messages: messages,
            title: messages.first?.text ?? "Chat on \(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))"
        )
        
        storage.save(conversation)
    }
    
    func loadSavedConversations() -> [Conversation] {
        if let data = UserDefaults.standard.data(forKey: "savedConversations"),
           let conversations = try? JSONDecoder().decode([Conversation].self, from: data) {
            return conversations
        }
        return []
    }
}
