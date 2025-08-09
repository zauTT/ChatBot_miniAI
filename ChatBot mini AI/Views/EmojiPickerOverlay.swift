//
//  EmojiPickerOverlay.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 09.08.25.
//


import UIKit

final class EmojiPickerOverlay: UIView {
    
    var onEmojiSelected: ((String) -> Void)?
    
    private let contentView = EmojiPickerView()
    
    private let backdrop = UIControl()

    override init(frame: CGRect) { super.init(frame: frame); setupView() }
    required init?(coder: NSCoder) { super.init(coder: coder); setupView() }

    private func setupView() {
        backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backdrop.addTarget(self, action: #selector(backgroundTapped), for: .touchUpInside)

        addSubview(backdrop); addSubview(contentView)
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            contentView.heightAnchor.constraint(equalToConstant: 60),
        ])

        contentView.onEmojiSelected = { [weak self] emoji in
            guard let self = self else { return }
            self.onEmojiSelected?(emoji)
            self.removeFromSuperview()
        }
    }

    @objc private func backgroundTapped() {
        removeFromSuperview()
    }
}
