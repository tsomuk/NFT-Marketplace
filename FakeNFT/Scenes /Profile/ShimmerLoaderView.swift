//
//  ShimmerLoaderView.swift
//  FakeNFT
//
//  Created by Анастасия on 29.03.2024.
//

import Foundation
import UIKit

final class ShimmerLoaderView: UIView {

    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    private func setupGradientLayer() {
        gradientLayer.cornerRadius = 12
        gradientLayer.frame = self.bounds

        let lightColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let darkColor = UIColor(white: 0.75, alpha: 1.0).cgColor

        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        self.layer.addSublayer(gradientLayer)
    }

    func startShimmeringEffect() {
        gradientLayer.isHidden = false
        gradientLayer.opacity = 1
        let animation = CABasicAnimation(keyPath: "locations")

        animation.fromValue = [-1.0, -0.5, 0]
        animation.toValue = [1, 1.5, 2]

        animation.duration = 1.5
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "shimmering")
    }

    func stopShimmeringEffect() {
        gradientLayer.removeAnimation(forKey: "shimmering")
        gradientLayer.isHidden = true
        gradientLayer.opacity = 0
    }
}
