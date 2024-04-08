//
//  UIView+extension.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 04.04.2024.
//

import UIKit

// Add array of subviews to view
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

// Appearance animation
extension UIView {
    func animateAlpha(_ alpha: CGFloat) {
        assert(alpha <= 1, "Alpha parameter should be in 0 to 1 range")
        UIView.animate(withDuration: 0.5) {
            self.alpha = alpha
        }
    }
}
