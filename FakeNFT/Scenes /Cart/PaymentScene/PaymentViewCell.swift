//
//  PaymentViewCell.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//


import UIKit

final class PaymentViewCell: UICollectionViewCell {
    
    lazy var currencyTitle = NFTTextLabel(text: "", fontSize: 13, fontColor: .nftBlack, fontWeight: .regular)
    lazy var currencySymbol = NFTTextLabel(text: "",fontSize: 13, fontColor: .nftGreen, fontWeight: .regular)
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [currencyTitle, currencySymbol])
        vStack.axis = .vertical
        vStack.spacing = 0
        return vStack
    }()
    
    lazy var currencyImage: UIImageView = {
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
        currencyImage.image = currency.image
    }
    
    func setupAppearance() {
        
        contentView.addSubviews(vStack, currencyImage)
        
        currencyImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(36)
        }
        
        vStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(currencyImage.snp.trailing).offset(4)
        }
    }
}
