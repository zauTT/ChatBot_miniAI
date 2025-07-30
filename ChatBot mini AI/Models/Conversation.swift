//
//  Conversation.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 30.07.25.
//

import Foundation

struct Conversation: Codable {
    let id: UUID
    let date: Date
    let messages: [ChatMessage]
    let title: String
}
