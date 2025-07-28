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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupControllers()
    }
    
    private func setupControllers() {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        menuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.bounds.height)
        menuVC.view.backgroundColor = .systemBackground
        
        addChild(chatVC)
        view.addSubview(chatVC.view)
        chatVC.didMove(toParent: self)
        chatVC.view.frame = view.bounds
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
//        chatVC.view.addGestureRecognizer(tapGesture)
        
        chatVC.onMenuTap = { [weak self] in
            self?.toggleMenu()
        }
    }
    
    @objc private func menuButtonTapped() {
        toggleMenu()
    }
    
    @objc private func toggleMenu() {
        isMenuOpen.toggle()
        let xOffset: CGFloat = isMenuOpen ? menuWidth : 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.chatVC.view.frame.origin.x = xOffset
        }
    }
}
