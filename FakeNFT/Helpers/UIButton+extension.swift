//
//  UIButton+extension.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 04.04.2024.
//

import UIKit

final class NFTButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = .nftBlack
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.setTitleColor(.nftWhite, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
