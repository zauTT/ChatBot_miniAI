//
//  ChatService.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//


import Foundation

class ChatService {
    func sendMessage(_ message: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "model": "openchat/openchat-3.5",
            "messages": [
                ["role": "user", "content": message]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("❌ Failed to encode JSON body: \(error)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let messageDict = choices.first?["message"] as? [String: Any],
                   let content = messageDict["content"] as? String {
                    completion(content)
                } else {
                    print("❌ Unexpected response format")
                    completion(nil)
                }
            } catch {
                print("❌ Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
