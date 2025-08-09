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

        DispatchQueue.main.async {
            self.messages.append(userMessage)
            self.onUpdate?()
            self.addTypingIndicator()
        }

        chatService.sendMessage(text) { [weak self] reply in
            guard let self = self, let reply = reply else { return }

            DispatchQueue.main.async {
                self.removeTypingIndicator()

                let aiMessage = ChatMessage(text: reply, sender: .ai)
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
    
    func updateMessage(at index: Int, with message: ChatMessage) {
        guard messages.indices.contains(index) else { return }
        messages[index] = message
        saveCurrentConversation()
    }
    
    var messageCount: Int {
        return messages.count
    }
    
    func loadSavedConversations() -> [Conversation] {
        return storage.fetchAll()
    }
    
    //MARK: - Typing Indicator
    
    func addTypingIndicator() {
        let typing = ChatMessage(text: "", sender: .ai)
        messages.append(typing)
        onUpdate?()
    }

    func removeTypingIndicator() {
        messages.removeAll { $0.sender == .ai && $0.text.isEmpty }
        onUpdate?()
    }
    
    //MARK: - Emoji Reaction
    
    func addReaction(_ emoji: String, to messageID: UUID) {
        if let index = messages.firstIndex(where: { $0.id == messageID }) {
            if !messages[index].reactions.keys.contains(emoji) {
                messages[index].reactions[emoji] = 1
            } else {
                messages[index].reactions[emoji, default: 0] += 1
            }
            onUpdate?()
            saveCurrentConversation()
        }
    }
}
