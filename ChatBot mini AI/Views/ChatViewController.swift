//
//  ChatViewController.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 27.07.25.
//


import UIKit

class ChatViewController: UIViewController {
    
    private let viewModel = ChatViewModel(storage: ConversationStorage())
    private var emojiBackgroundView: UIView?
    
    private let headerView = UIView()
    private let menuButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    private let mainContainerView = UIView()
    private let tableView = UITableView()
    private let inputContainerView = UIView()
    private let inputTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    
    private var inputContainerBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var currentConversationID: UUID? {
        return viewModel.currentConversation?.id
    }
    
    var onMenuTap: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "miniAI - Chatbot"
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
        
        tableView.register(TypingIndicatorCell.self, forCellReuseIdentifier: TypingIndicatorCell.identifier)
        
        setupMainContainer()
        setupHeader()
        setupTableView()
        setupInputBar()
        setupConstraints()
        setupKeyboardObservers()
        dismissEmojiPicker()
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
        inputTextField.layer.cornerRadius = 13
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
    
    // MARK: - Keyboard/Emoji Handling
    
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
    
    func showEmojiPicker(below cell: UITableViewCell) {
        dismissEmojiPicker()

        guard let window = view.window else { return }
        
        let backgroundView = UIView(frame: window.bounds)
//        backgroundView.backgroundColor = UIColor.clear
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissEmojiPicker))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tapGesture)
        
        let pickerView = EmojiPickerView(frame: CGRect.zero)
        pickerView.onEmojiSelected = { [weak self] emoji in
            print("Selected: \(emoji)")
            self?.dismissEmojiPicker()
        }
        
        backgroundView.addSubview(pickerView)
            
        window.addSubview(backgroundView)
        
        let cellFrame = cell.convert(cell.bounds, to: window)
        let pickerHeight: CGFloat = 60
        let pickerWidth = window.bounds.width - 32
        let spaceBelow = window.bounds.height - cellFrame.maxY
        let showAbove = spaceBelow < pickerHeight + 20

        let pickerY: CGFloat = showAbove ? cellFrame.minY - pickerHeight - 8 : cellFrame.maxY + 8

        pickerView.frame = CGRect(
            x: 16,
            y: pickerY,
            width: pickerWidth,
            height: pickerHeight
        )
        
        self.emojiBackgroundView = backgroundView
        
    }

    @objc func dismissEmojiPicker() {
        print("dismissEmojiPicker called")
        emojiBackgroundView?.removeFromSuperview()
        emojiBackgroundView = nil
    }

    
    // MARK: - Actions
    
    @objc private func menuButtonTapped() {
        print("Menu button tapped")
        HapticManager.shared.impact(style: .light)
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
    
    func loadConversation(_ conversation: Conversation) {
        self.viewModel.loadConversation(conversation)
        self.scrollToBottom()
    }
    
    func updateBackgroundColor(for isMenuOpen: Bool, style: UIUserInterfaceStyle) {
        let mainBgColor: UIColor
        if isMenuOpen {
            mainBgColor = style == .dark ? .darkGray : .lightGray
        } else {
            mainBgColor = .systemBackground
        }
        
        self.view.backgroundColor = mainBgColor
        self.tableView.backgroundColor = mainBgColor
        inputTextField.backgroundColor = mainBgColor
        
        if isMenuOpen {
            inputContainerView.backgroundColor = mainBgColor
        } else {
            inputContainerView.backgroundColor = .secondarySystemBackground
        }
    }
}

// MARK: - UITableViewDataSource, UIGestureRecognizerDelegate

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.message(at: indexPath.row)

        if message.sender == .ai && message.text.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypingIndicatorCell.identifier, for: indexPath) as! TypingIndicatorCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as! ChatMessageCell
        cell.configure(with: message)
        
        cell.onEmojiReaction = { [weak self] emoji in
            guard let self = self else { return }

            var message = self.viewModel.message(at: indexPath.row)

            if let count = message.reactions[emoji] {
                message.reactions[emoji] = count + 1
            } else {
                message.reactions[emoji] = 1
            }

            self.viewModel.updateMessage(at: indexPath.row, with: message)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
    }
}

extension ChatViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let pickerView = emojiBackgroundView?.subviews.first {
            let touchPoint = touch.location(in: emojiBackgroundView)
            let insidePicker = pickerView.frame.contains(touchPoint)
            print("Tap location: \(touchPoint), picker frame: \(pickerView.frame), insidePicker: \(insidePicker)")
            if insidePicker {
                return false
            }
        }
        print("gestureRecognizer(_:shouldReceive:) called")
        print("Tap outside picker — should recognize gesture")
        return true
    }
}
