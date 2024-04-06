//
//  UIView+extension.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 04.04.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
