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
    
    private(set) var currentConversation: Conversation?

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
                self.saveCurrentConversation()
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
        currentConversation = nil
        onUpdate?()
    }
    
    func loadConversation(_ conversation: Conversation) {
        self.messages = conversation.messages
        self.currentConversation = conversation
        onUpdate?()
    }
    
    func saveCurrentConversation() {
        guard !messages.isEmpty else { return }
        
        if var existing = currentConversation {
            existing.messages = messages
            currentConversation = existing
            storage.update(existing)
        } else {
            let newConversation = Conversation(
                id: UUID(),
                date: Date(),
                messages: messages,
                title: messages.first?.text ?? "Chat on \(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))"
            )
            currentConversation = newConversation
            storage.save(newConversation)
        }
    }
    
    func message(at index: Int) -> ChatMessage {
        return messages[index]
    }
    
    var messageCount: Int {
        return messages.count
    }
    
    func loadSavedConversations() -> [Conversation] {
        return storage.fetchAll()
    }
}
