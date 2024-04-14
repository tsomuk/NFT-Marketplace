//
//  UILabel+extension.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 04.04.2024.
//

import UIKit

final class NFTTextLabel: UILabel {
    init(text: String, fontSize: CGFloat, fontColor: UIColor, fontWeight: UIFont.Weight) {
        super.init(frame: .zero)
        self.text = text
        self.numberOfLines = 0
        self.textColor = fontColor
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
