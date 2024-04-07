//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//

import UIKit

final class DeleteViewController: UIViewController {
    
    private var deleteAction: () -> ()
    private var image: UIImage
    
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = NFTButton(title: "Удалить")
        deleteButton.setTitleColor(.nftRed, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = NFTButton(title: "Вернуться")
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.contentMode = .scaleAspectFit
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        nftImage.image = image
        return nftImage
    }()
    
    private lazy var conformationLabel = NFTTextLabel(
        text: "Вы уверены, что хотите удалить объект из корзины?",
        fontSize: 13,
        fontColor: .nftBlack,
        fontWeight: .regular
    )
    
    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView(arrangedSubviews: [deleteButton, cancelButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8
        buttonStack.distribution = .fillEqually
        return buttonStack
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [nftImage, conformationLabel, buttonStack])
        vStack.axis = .vertical
        vStack.spacing = 15
        vStack.alignment = .center
        return vStack
    }()
    
    init(image: UIImage, deleteAction: @escaping () -> ()) {
        self.deleteAction = deleteAction
        self.image = image
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        
        // Setting a transparent background with a blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .clear
        view.addSubview(vStack)
        
        conformationLabel.textAlignment = .center
        conformationLabel.snp.makeConstraints { make in
            make.leading.equalTo(deleteButton.snp.leading)
            make.trailing.equalTo(cancelButton.snp.trailing)
        }
        
        nftImage.snp.makeConstraints { make in
            make.width.height.equalTo(108)
        }
        
        vStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(44)
        }
    }
    
    private func buttonAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
    
    @objc private func deleteTapped() {
        buttonAnimation()
        deleteAction()
    }
    
    @objc private func cancelTapped() {
        buttonAnimation()
    }
}
