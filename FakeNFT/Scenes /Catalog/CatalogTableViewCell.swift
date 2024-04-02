//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Арина Колганова on 27.03.2024.
//
import Kingfisher
import SnapKit
import UIKit

final class CatalogTableViewCell: UITableViewCell {
    private lazy var catalogImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "ScheduleCell")

        layer.cornerRadius = 12
        clipsToBounds = true
        selectionStyle = .none

        contentView.addSubview(catalogImageView)
        contentView.addSubview(nameLabel)

        catalogImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaInsets)
            $0.height.equalTo(contentView.frame.width/2.45)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaInsets)
            $0.top.equalTo(catalogImageView.snp.bottom).offset(4)
            $0.bottom.equalTo(safeAreaInsets).inset(21)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageView?.kf.cancelDownloadTask()
    }

    func configure(imageURL: URL?, label: String) {
        guard let imageURL else { return }
        catalogImageView.kf.setImage(with: imageURL)
        nameLabel.text = label
    }
}
