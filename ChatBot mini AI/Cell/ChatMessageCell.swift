//
//  ChatMessageCell.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//


import UIKit

class ChatMessageCell: UITableViewCell {
    static let identifier = "ChatMessageCell"
    
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    
    private var leadingConstraint: NSLayoutConstraint? = nil
    private var trailingConstraint: NSLayoutConstraint? = nil
    
    private let reactionsLabel = UILabel()
    var onEmojiReaction:((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        contentView.addGestureRecognizer(longPress)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true

        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)

        reactionsLabel.font = UIFont.systemFont(ofSize: 14)
        reactionsLabel.textColor = .secondaryLabel
        reactionsLabel.numberOfLines = 1

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(reactionsLabel)
    }

    
    private func setupConstraints() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),

            reactionsLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            reactionsLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            reactionsLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            reactionsLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),

            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75)
        ])

        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    @objc private func handleLongPress(_ gr: UILongPressGestureRecognizer) {
        guard gr.state == .began, let parentVC = self.parentViewController else { return }
        let overlay = EmojiPickerOverlay(frame: parentVC.view.bounds)
        overlay.onEmojiSelected = { [weak self, weak overlay] emoji in self?.onEmojiReaction?(emoji)
            overlay?.removeFromSuperview()
        }
        parentVC.view.addSubview(overlay)
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        
        let formattedReactions = message.reactions.map { "\($0.key) x\($0.value)" }
        reactionsLabel.text = formattedReactions.joined(separator: " ")
        reactionsLabel.isHidden = message.reactions.isEmpty

        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        
        if message.sender == .user {
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            leadingConstraint?.isActive = false
            trailingConstraint?.isActive = true
        } else {
            bubbleView.backgroundColor = .secondarySystemBackground
            messageLabel.textColor = .label
            leadingConstraint?.isActive = true
            trailingConstraint?.isActive = false
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let vc = responder as? UIViewController {
                return vc
            }
            parentResponder = responder.next
        }
        return nil
    }
}
