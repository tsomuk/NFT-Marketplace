//
//  RatingCell.swift
//  FakeNFT
//
//  Created by mihail on 26.03.2024.
//

import UIKit
import SnapKit

final class RatingCell: UITableViewCell {
    static let identifier = "RatingCell"
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = ColorsApp.nftLightGray
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    lazy var numberRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let image = UIImage(named: "profile")
        let imageView = UIImageView(image: image)
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Alex"
        
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "112"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: RatingCell.identifier)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        contentView.addSubview(view)
        contentView.addSubview(numberRatingLabel)
        
        [avatarImageView,
         nameLabel,
         ratingLabel,].forEach { view in
            self.view.addSubview(view)
        }
        
        view.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.left.equalToSuperview().inset(35)
            make.right.equalToSuperview().inset(0)
        }
        
        numberRatingLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(30)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview().inset(26)
            make.left.equalTo(16)
            make.height.width.equalTo(28)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).inset(-8)
            make.bottom.top.equalToSuperview().inset(26)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(26)
            make.left.equalTo(nameLabel.snp.right).inset(-16)
        }
    }
}
