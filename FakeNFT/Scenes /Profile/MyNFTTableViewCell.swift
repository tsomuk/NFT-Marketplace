//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Анастасия on 02.04.2024.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class MyNFTTableViewCell: UITableViewCell {
    // MARK: -  Properties & Constants

    private let myNFTImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockNFT")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "heart.fill"),
            for: .normal)
        button.tintColor = UIColor(named: "nftLightGray")
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside)
        return button
    }()

    private lazy var myNFTStack4: UIStackView = {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            myNFTImage,
            myNFTStack3
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 20
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        return horizontalStackView
    }()

    private lazy var myNFTStack3: UIStackView = {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            myNFTStack1,
            myNFTStack2
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 39
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()

    private lazy var myNFTStack1: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            myNFTNameLabel,
            myNFTStarsStackView,
            myNFTAuthorLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalCentering
        return verticalStackView
    }()

    private lazy var myNFTStack2: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            priceLabel,
            myNFTPriceLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .equalCentering
        return verticalStackView
    }()

    private let myNFTStarsStackView: UIStackView = {
        let starsStackView = UIStackView()
        starsStackView.axis = .horizontal
        starsStackView.spacing = 2
        return starsStackView
    }()

    private let myNFTNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    private let myNFTAuthorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let myNFTPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    // MARK: -  Overrride

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -  Private Methods

    private func setUpView() {
        contentView.addSubview(myNFTStack4)
        contentView.addSubview(likeButton)

        myNFTImage.snp.makeConstraints { make in
            make.width.height.equalTo(108)
        }
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.trailing.equalTo(myNFTImage.snp.trailing)
            make.top.equalTo(myNFTImage.snp.top)
        }
        myNFTStack4.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView).inset(16)
            make.width.equalToSuperview().offset(-16)
        }
    }

    func configureMyNFT(with NFT: NFTInfo) {
        myNFTNameLabel.text = NFT.name
        myNFTAuthorLabel.text = NFT.author
        myNFTPriceLabel.text = "\(NFT.price) ETH"
        configureRatingStars(with: NFT.rating)

        if let imageURL = URL(string: NFT.images.first ?? "") {
            myNFTImage.kf.setImage(with: imageURL)
            myNFTImage.layer.cornerRadius = 12
            myNFTImage.layer.masksToBounds = true
         }
    }

    private func configureRatingStars(with rating: Int) {
        myNFTStarsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let totalStars = 5
        let starConfiguration = UIImage.SymbolConfiguration(pointSize: 12)

        for i in 1...totalStars {
            let starImageView = UIImageView()
            if i <= rating {
                starImageView.image = UIImage(
                    systemName: "star.fill",
                    withConfiguration: starConfiguration
                )
                starImageView.tintColor = UIColor(named: "nftYellow")
            } else {
                starImageView.image = UIImage(
                    systemName: "star.fill",
                    withConfiguration: starConfiguration
                )
                starImageView.tintColor = UIColor(named: "nftLightGray")
            }
            myNFTStarsStackView.addArrangedSubview(starImageView)
        }
    }

    @objc private func likeButtonTapped() {
        print("tapped")
    }
}
