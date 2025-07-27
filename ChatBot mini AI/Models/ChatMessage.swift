//
//  ChatMessage.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//

import Foundation

struct ChatMessage: Identifiable {
    
    enum sender {
        case user
        case ai
    }
    
    let id = UUID()
    let text: String
    let sender: sender
}
