//
//  PaymentViewCell.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//


import UIKit
import Kingfisher

final class PaymentViewCell: UICollectionViewCell {
    
    private lazy var currencyTitle = NFTTextLabel(text: "", fontSize: 13, fontColor: .nftBlack, fontWeight: .regular)
    private lazy var currencySymbol = NFTTextLabel(text: "",fontSize: 13, fontColor: .nftGreen, fontWeight: .regular)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyTitle, currencySymbol])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var currencyImage: UIImageView = {
        let currencyImage = UIImageView()
        currencyImage.layer.cornerRadius = 6
        currencyImage.layer.masksToBounds = true
        return currencyImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(currency: Currency){
        currencyTitle.text = currency.title
        currencySymbol.text = currency.name
        currencyImage.kf.setImage(with: currency.image, placeholder: UIImage(systemName: "bitcoinsign.arrow.circlepath"))
    }
    
    private func setupAppearance() {
        
        contentView.addSubviews(stackView, currencyImage)
        
        currencyImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(36)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(currencyImage.snp.trailing).offset(4)
        }
    }
}
