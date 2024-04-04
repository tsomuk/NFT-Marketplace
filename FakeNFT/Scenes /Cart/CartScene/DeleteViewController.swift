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
        nftImage.image = image
        nftImage.contentMode = .scaleAspectFit
        return nftImage
    }()

    private let conformationLabel = NFTTextLabel(
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
        vStack.alignment = .leading
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

        // Установка прозрачного фона с эффектом размытия
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
    }

    private func setupAppearance() {
        view.backgroundColor = .clear
        view.addSubview(vStack)

        conformationLabel.textAlignment = .center

        vStack.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
        }

        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(44)
        
            nftImage.snp.makeConstraints { make in
                make.height.equalTo(108)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    @objc private func deleteTapped() {
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 0
            } completion: { _ in
                self.dismiss(animated: true)
            }
            deleteAction()
        }
        
        @objc private func cancelTapped() {
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 0
            } completion: { _ in
                self.dismiss(animated: true)
            }
        }
    }
