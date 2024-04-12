//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Анастасия on 24.03.2024.
//

import Foundation
import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(named: "nftBlack")
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "nftWhite")
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        let chevron = UIImage(systemName: "chevron.right")
        accessoryView = UIImageView(image: chevron)

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    func setTitleLabel(text: String) {
        titleLabel.text = text
    }
}
