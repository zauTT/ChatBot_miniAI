//
//  SideMenuView.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 28.07.25.
//

import UIKit

class MenuViewController: UIViewController {
    
    var onNewChatTap: (() -> Void)?
    var onConversationSelected: ((Conversation) -> Void)?
    
    private let storage = ConversationStorage.shared

    private var conversations: [Conversation] = []

    private let newChatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➕ New Chat", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ConversationCell")
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadConversations()
    }
    
    private func setupUI() {
        view.addSubview(newChatButton)
        view.addSubview(tableView)

        newChatButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: newChatButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        newChatButton.addTarget(self, action: #selector(newChatTapped), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadConversations() {
        conversations = storage.fetchAll()
        tableView.reloadData()
    }

    @objc private func newChatTapped() {
        print("New Chat button tapped")
        onNewChatTap?()
    }
}

// MARK: - UITableViewDataSource & Delegate

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath)
        let convo = conversations[indexPath.row]
        cell.textLabel?.text = convo.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            onNewChatTap?()
        } else {
            let selectedConversation = conversations[indexPath.row]
            print("Tapped saved conversation: \(selectedConversation.title)")
            onConversationSelected?(selectedConversation)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
