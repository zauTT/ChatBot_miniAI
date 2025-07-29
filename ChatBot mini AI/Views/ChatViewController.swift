//
//  ChatViewController.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    private let viewModel = ChatViewModel()
    
    private let headerView = UIView()
    private let menuButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    private let mainContainerView = UIView()
    private let tableView = UITableView()
    private let inputContainerView = UIView()
    private let inputTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    private var inputContainerBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var onMenuTap: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "miniAI - Chatbot"
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
        
        setupMainContainer()
        setupHeader()
        setupTableView()
        setupInputBar()
        setupConstraints()
        setupKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Views
    
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44)
        ])

        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.tintColor = .label
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        headerView.addSubview(menuButton)

        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            menuButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        titleLabel.text = "miniAI - chatBot"
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }

    private func setupMainContainer() {
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(tableView)
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.scrollsToTop = false
    }

    private func setupInputBar() {
        inputContainerView.backgroundColor = .secondarySystemBackground
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(inputContainerView)

        inputTextField.placeholder = "Ask away..."
        inputTextField.borderStyle = .roundedRect
        inputTextField.layer.cornerRadius = 8
        inputTextField.layer.masksToBounds = true
        inputTextField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setTitle("↑", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        inputContainerView.addSubview(inputTextField)
        inputContainerView.addSubview(sendButton)
    }

    private func setupConstraints() {
        inputContainerBottomConstraint = inputContainerView.bottomAnchor.constraint(equalTo: mainContainerView.safeAreaLayoutGuide.bottomAnchor)
        inputContainerBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),

            inputContainerView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            inputContainerBottomConstraint,

            inputTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 6),
            inputTextField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -6),
            inputTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 12),
            inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            inputTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),

            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 32),
        ])
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        inputContainerBottomConstraint.constant = -keyboardHeight

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        inputContainerBottomConstraint.constant = 0

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Actions

    @objc private func menuButtonTapped() {
        print("Menu button tapped")
        onMenuTap?()
    }

    @objc private func newChatButtonTapped() {
        viewModel.clearMessages()
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
    }

    @objc private func sendButtonTapped() {
        guard let text = inputTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        inputTextField.text = ""
        viewModel.send(text)
    }

    @objc private func scrollToBottom() {
        let count = viewModel.messageCount
        guard count > 0 else { return }
        let indexPath = IndexPath(row: count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func startNewConversation() {
        viewModel.clearMessages()
        tableView.reloadData()
        inputTextField.text = ""
        scrollToBottom()
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        let message = viewModel.message(at: indexPath.row)
        cell.configure(with: message)
        return cell
    }
}
