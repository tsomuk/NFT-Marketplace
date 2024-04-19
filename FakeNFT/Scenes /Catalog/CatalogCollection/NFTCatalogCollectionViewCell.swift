//
//  NFTCatalogCollectionViewCell.swift
//  FakeNFT
//
//  Created by Арина Колганова on 06.04.2024.
//
import ProgressHUD
import UIKit

protocol CellDelegate: AnyObject {
    func reloadBug(model: NftCellModel)
    func reloadLike(model: NftCellModel)
}

final class NFTCatalogCollectionViewCell: UICollectionViewCell {
    weak var delegate: CellDelegate?

    private var model: NftCellModel?

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()

    private lazy var bagButton: UIButton = {
        let button = UIButton()
        button.tintColor = .nftBlack
        button.addTarget(self, action: #selector(bagDidTapped), for: .touchUpInside)
        return button
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()

    private lazy var labelWithBagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(bagButton)
        return stackView
    }()

    private lazy var labelWithBagAndRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.addArrangedSubview(ratingStackView)
        stackView.addArrangedSubview(labelWithBagStackView)
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelWithBagAndRatingStackView)
        return stackView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(likeDidTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 12

        contentView.addSubview(stackView)
        contentView.addSubview(indicator)
        contentView.addSubview(likeButton)

        stackView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.bottom).inset(20)
        }

        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width)
        }

        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalTo(contentView)
        }

        likeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(imageView).inset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: NftCellModel) {
        self.model = model
        imageView.kf.setImage(with: model.images.first)
        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        if ratingStackView.subviews.count < 5 {
            for star in 1...5 {
                star <= model.rating ? setRating(isFull: true) : setRating(isFull: false)
            }
        }
        bagButton.setImage(model.isOrders ? UIImage(named: "basketDelete") : UIImage(named: "basketEmpty"), for: .normal)
        likeButton.tintColor = model.isLikes ? UIColor(named: "nftRed") : .white
    }

    func startAnimation() {
        indicator.startAnimating()
    }

    func stopAnimation() {
        indicator.stopAnimating()
    }

    private func setRating(isFull: Bool) {
        let imageView = UIImageView()
        imageView.frame(forAlignmentRect: .init(x: 0.0, y: 0.0, width: 12.0, height: 12.0))
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = isFull ? .yellow  : UIColor(named: "nftLightGray")
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width)
            $0.height.equalTo(12)
        }
        ratingStackView.addArrangedSubview(imageView)
    }

    @objc private func bagDidTapped() {
        guard let model else { return }
        delegate?.reloadBug(model: model)
    }

    @objc private func likeDidTapped() {
        guard let model else { return }
        delegate?.reloadLike(model: model)
    }
}
