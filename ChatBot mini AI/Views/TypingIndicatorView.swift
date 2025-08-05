//
//  TypingIndicatorView.swift
//  ChatBot mini AI
//
//  Created by Giorgi Zautashvili on 05.08.25.
//


import UIKit

class TypingIndicatorView: UIView {

    private var dotLayers: [CAShapeLayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDots()
    }

    private func setupDots() {
        dotLayers.forEach { $0.removeFromSuperlayer() }
        dotLayers = []

        let dotCount = 3
        let dotSize: CGFloat = 8
        let spacing: CGFloat = 8

        for i in 0..<dotCount {
            let dot = CAShapeLayer()
            let x = CGFloat(i) * (dotSize + spacing)
            dot.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).cgPath
            dot.fillColor = UIColor.gray.cgColor
            dot.frame = CGRect(x: x, y: 0, width: dotSize, height: dotSize)

            layer.addSublayer(dot)
            dotLayers.append(dot)
        }

        startAnimating()
    }

    private func startAnimating() {
        for (index, dot) in dotLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0.3
            animation.toValue = 1.0
            animation.duration = 0.5
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.2
            dot.add(animation, forKey: "opacityAnimation")
        }
    }

    func restartAnimation() {
        dotLayers.forEach { $0.removeAllAnimations() }
        startAnimating()
    }
}
