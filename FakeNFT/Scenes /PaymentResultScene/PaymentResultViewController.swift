//
//  PaymentResultViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//

import UIKit

class PaymentResultViewController: UIViewController {
    
    private lazy var payButton: UIButton = {
        let payButton = NFTButton(title: "Вернуться в каталог")
        payButton.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
        return payButton
    }()
    
    private lazy var holderImage: UIImageView = {
        let holderImage = UIImageView()
        holderImage.image = UIImage(named: "paymentHolder")
        holderImage.contentMode = .scaleAspectFit
        return holderImage
    }()
    
    private let paymentLabel = NFTTextLabel(
        text: "Успех! Оплата прошла, поздравляем с покупкой!",
        fontSize: 22,
        fontColor: .nftBlack,
        fontWeight: .bold
    )
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [holderImage, paymentLabel])
        vStack.axis = .vertical
        vStack.spacing = 20
        return vStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    @objc private func backToCatalog() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupAppearance() {
        
        view.backgroundColor = .nftWhite
        
        paymentLabel.numberOfLines = 2
        paymentLabel.textAlignment = .center
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.addSubviews(payButton, vStack)
        
        vStack.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
        }
        
        holderImage.snp.makeConstraints { make in
            make.height.equalTo(278)
        }
        
        payButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}

