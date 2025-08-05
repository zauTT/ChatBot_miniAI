//
//  TypingIndicatorCell.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 05.08.25.
//

import UIKit

class TypingIndicatorCell: UITableViewCell {
    static let identifier = "TypingIndicatorCell"

    private let indicatorView = TypingIndicatorView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.restartAnimation()
    }

    private func setup() {
        contentView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 6),
            indicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        indicatorView.restartAnimation()
    }
}
