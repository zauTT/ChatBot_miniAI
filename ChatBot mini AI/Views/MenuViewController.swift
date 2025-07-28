//
//  SideMenuView.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 28.07.25.
//

import UIKit

class MenuViewController: UIViewController {
    let newChatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➕ New Chat", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()

    let conversationsTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 2, height: 0)

        setupViews()
    }

    private func setupViews() {
        view.addSubview(newChatButton)
        view.addSubview(conversationsTableView)

        newChatButton.translatesAutoresizingMaskIntoConstraints = false
        conversationsTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            newChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newChatButton.heightAnchor.constraint(equalToConstant: 44),

            conversationsTableView.topAnchor.constraint(equalTo: newChatButton.bottomAnchor, constant: 10),
            conversationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conversationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conversationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
