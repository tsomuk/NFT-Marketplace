//
//  ChosenNFTViewCell.swift
//  FakeNFT
//
//  Created by Анастасия on 09.04.2024.
//

import Foundation
import UIKit

final class ChosenNFTViewCell: UICollectionViewCell {
    
    // MARK: -  Properties & Constants

    private let myChosenNFTImage: UIImageView = {
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
        button.tintColor = UIColor(named: "nftRed")
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside)
        return button
    }()

    private lazy var myChosenNFTStackMain: UIStackView = {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            myChosenNFTImage,
            myNFTStackLabelRatingPrice
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        return horizontalStackView
    }()

    private lazy var myNFTStackLabelRatingPrice: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            myChosenNFTNameLabel,
            myChosenNFTStarsStackView,
            myChosenNFTPriceLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .equalCentering
        return verticalStackView
    }()

    private let myChosenNFTStarsStackView: UIStackView = {
        let starsStackView = UIStackView()
        starsStackView.axis = .horizontal
        starsStackView.spacing = 2
        return starsStackView
    }()

    private let myChosenNFTNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let myChosenNFTPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -  Private Methods

    func setupViews() {
        contentView.addSubview(myChosenNFTStackMain)
        contentView.addSubview(likeButton)
        
        myChosenNFTImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(29.63)
            make.trailing.equalTo(myChosenNFTImage.snp.trailing)
            make.top.equalTo(myChosenNFTImage.snp.top)
        }
        myChosenNFTStackMain.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView)
        }
    }

    func configureMyChosenNFT(with NFT: NFTInfo) {
        myChosenNFTNameLabel.text = NFT.name
        myChosenNFTPriceLabel.text = "\(NFT.price) ETH"
        configureRatingStars(with: NFT.rating)
        
        if let imageURL = URL(string: NFT.images.first ?? "") {
            myChosenNFTImage.kf.setImage(with: imageURL)
            myChosenNFTImage.layer.cornerRadius = 12
            myChosenNFTImage.layer.masksToBounds = true
         }
    }

    private func configureRatingStars(with rating: Int) {
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
            myChosenNFTStarsStackView.addArrangedSubview(starImageView)
        }
    }

    @objc private func likeButtonTapped() {
        print("tapped")
    }
}
