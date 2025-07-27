
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
