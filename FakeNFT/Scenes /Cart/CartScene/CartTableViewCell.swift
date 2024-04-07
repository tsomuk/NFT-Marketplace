//
//  File.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - Protocols

protocol DeleteNftDelegate: AnyObject {
    func deleteNft(id: String, image: UIImage)
}

// MARK: - Class

final class CartTableViewCell: UITableViewCell {

// MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Varibles
    
    weak var delegate: DeleteNftDelegate?
    private var nftID: String?
    
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        return nftImage
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return nameLabel
    }()

    private lazy var ratingView: UIStackView = {
        let ratingView = UIStackView()
        return ratingView
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "Цена"
        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return priceLabel
    }()

    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()

        priceValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return priceValueLabel
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, priceLabel, priceValueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()

    private lazy var deleteButton = {
        let removeButton = UIButton()
        removeButton.setImage(.basketDelete, for: .normal)
        removeButton.tintColor = .nftBlack
        removeButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return removeButton
    }()
    
// MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in ratingView.subviews {
            view.removeFromSuperview()
        }
    }

    private func setupAppearance() {
        contentView.addSubviews(nftImage, stack, deleteButton)

        nftImage.snp.makeConstraints { make in
            make.height.width.equalTo(108)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        stack.snp.makeConstraints { make in
            make.leading.equalTo(nftImage.snp.trailing).offset(40)
            make.centerY.equalToSuperview()
        }

        deleteButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    func configCell(data: Nft) {
        self.nftID = data.id
        nftImage.kf.setImage(with: data.images[0], placeholder: UIImage(systemName: "photo"))
        nameLabel.text = data.name
        configureRatingStars(with: data.rating)
        priceValueLabel.text = "\(data.price) ETH"
    }

    @objc func deleteItem() {
        guard let nftID = nftID else {
            assertionFailure("invalid nftID")
            return
        }
        delegate?.deleteNft(id: nftID, image: nftImage.image ?? UIImage())
    }

    private func configureRatingStars(with rating: Int) {
        stack.insertArrangedSubview(ratingView, at: 1)
        let totalStars = 5
        let starConfiguration = UIImage.SymbolConfiguration(pointSize: 12)
        for i in 1...totalStars {
            let starImageView = UIImageView()
            if i <= rating {
                starImageView.image = UIImage(systemName: "star.fill", withConfiguration: starConfiguration)
                starImageView.tintColor = .systemYellow
            } else {
                starImageView.image = UIImage(systemName: "star", withConfiguration: starConfiguration)
                starImageView.tintColor = .systemGray
            }
            ratingView.addArrangedSubview(starImageView)
        }
    }
}