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
    
    private var buttons: [UIButton] = []
    
    override var intrinsicContentSize: CGSize {
        let buttonWidth: CGFloat = 44
        let spacing: CGFloat = 12
        let totalWidth = CGFloat(emojis.count) * buttonWidth + CGFloat(emojis.count - 1) * spacing + 20
        let height: CGFloat = 60
        return CGSize(width: totalWidth, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupButtons() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        for emoji in emojis {
            let button = UIButton(type: .system)
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 28)
            button.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.title(for: .normal) else { return }
        buttons.forEach { $0.isUserInteractionEnabled = false }
        onEmojiSelected?(emoji)
    }
}
