//
//  ChatMessage.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    enum Sender: String, Codable {
        case user
        case ai
    }

    let id: UUID
    let text: String
    let sender: Sender
    var reactions: [String: Int] = [:]

    init(id: UUID = UUID(), text: String, sender: Sender, reactions: [String: Int] = [:]) {
        self.id = id
        self.text = text
        self.sender = sender
        self.reactions = reactions
    }
}
