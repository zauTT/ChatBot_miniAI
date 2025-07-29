//
//  SideMenuView.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 28.07.25.
//

import UIKit

class MenuViewController: UIViewController {
    
    var onNewChatTap: (() -> Void)?
    
    let newChatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➕ New Chat", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()

    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            setupUI()
        }

        private func setupUI() {
            view.addSubview(newChatButton)
            newChatButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                newChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            ])

            newChatButton.addTarget(self, action: #selector(newChatTapped), for: .touchUpInside)
        }

        @objc private func newChatTapped() {
            onNewChatTap?()
        }
    }
