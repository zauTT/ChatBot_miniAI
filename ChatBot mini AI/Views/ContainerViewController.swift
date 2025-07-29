//
//  ContainerViewController.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 28.07.25.
//

import UIKit

class ContainerViewController: UIViewController {
    private let menuVC = MenuViewController()
    private let chatVC = ChatViewController()
    
    private var isMenuOpen = false
    private let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.75
    private let dimmingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        addChild(chatVC)
        view.addSubview(chatVC.view)
        chatVC.view.frame = view.bounds
        chatVC.didMove(toParent: self)
        
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.bounds.height)
        menuVC.didMove(toParent: self)
        
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmingView.frame = view.bounds
        dimmingView.alpha = 0
        view.insertSubview(dimmingView, aboveSubview: menuVC.view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        dimmingView.addGestureRecognizer(tapGesture)
        
        chatVC.onMenuTap = { [weak self] in
            self?.toggleMenu()
        }
        
        menuVC.onNewChatTap = { [weak self] in
            self?.startNewChat()
        }
    }
    
    @objc private func toggleMenu() {
        isMenuOpen.toggle()

        let menuTargetX: CGFloat = isMenuOpen ? 0 : -menuWidth
        let dimAlpha: CGFloat = isMenuOpen ? 1 : 0

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuVC.view.frame.origin.x = menuTargetX
            self.dimmingView.alpha = dimAlpha
        }
    }
    
    private func startNewChat() {
        chatVC.startNewConversation()
        toggleMenu()
    }
}
