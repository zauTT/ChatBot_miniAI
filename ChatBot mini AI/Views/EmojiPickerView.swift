//
//  EmojiPickerView.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 06.08.25.
//


import UIKit

class EmojiPickerView: UIView {
    
    var onEmojiSelected: ((String) -> Void)?
    
    private let emojis = ["😂", "👍", "❤️", "😮", "😢", "🔥"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtons()
        
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        for emoji in emojis {
            let button = UIButton(type: .system)
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 28)
            button.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    @objc private func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.title(for: .normal) else { return }
        onEmojiSelected?(emoji)
        self.removeFromSuperview()
    }
}
