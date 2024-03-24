//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Анастасия on 24.03.2024.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

protocol ProfileEditDelegate: AnyObject {
    func editProfileVCDismissed(_ vc: EditProfileViewController)
}

final class EditProfileViewController: UIViewController {
    
    // MARK: -  Properties & Constants

    weak var delegate: ProfileEditDelegate?
    private var profileInfo: ProfileInfo?
    
    private lazy var closeEditVCButton: UIButton = {
        let button = UIButton(type: .system)
        let xmarkImage = UIImage(systemName: "xmark")
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = UIColor(named: "nftBlack")
        button.addTarget(
            self,
            action: #selector(closeEditVCButtonTapped),
            for: .touchUpInside)
        return button
    }()

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testProfileImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var changeProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "Сменить\nфото",
            for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 35
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.addTarget(
            self,
            action: #selector(changeProfileImageButtonTapped),
            for: .touchUpInside)
        return button
    }()

    private lazy var editProfileStackMain: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            editProfileStack1,
            editProfileStack2,
            editProfileStack3
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 24
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        return verticalStackView
    }()

    private lazy var editProfileStack1: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            nameLabel,
            nameTextField
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        return verticalStackView
    }()

    private lazy var editProfileStack2: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            bioLabel,
            bioTextField
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        return verticalStackView
    }()

    private lazy var editProfileStack3: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            siteLabel,
            siteTextField
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        return verticalStackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваше имя"
        textField.textColor = UIColor(named: "nftBlack")
        textField.backgroundColor = UIColor(named: "nftLightGray")
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.layer.cornerRadius = 12
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        return textField
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let bioTextField: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(named: "nftBlack")
        textView.backgroundColor = UIColor(named: "nftLightGray")
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }()

    private let siteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let siteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваш сайт"
        textField.textColor = UIColor(named: "nftBlack")
        textField.backgroundColor = UIColor(named: "nftLightGray")
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.layer.cornerRadius = 12

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always

        return textField
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        //TODO: Замени на fetchDataForProfile()
        profileInfo = ProfileInfo(
            name: "John Doe",
            avatar: "https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG",
            description: "Better go than stay forever.",
            website: "https://example.com",
            nfts: ["1", "2", "3"],
            likes: ["1", "2", "3"],
            id: "1"
        )
        if let profileInfo = profileInfo {
            convert(with: profileInfo)
        }
    }

    // MARK: -  Private Methods

    private func setUpView() {
        view.addSubview(closeEditVCButton)
        view.addSubview(profileImage)
        profileImage.addSubview(changeProfileImageButton)
        view.addSubview(editProfileStackMain)

        closeEditVCButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(42)
        }
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        changeProfileImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        bioTextField.snp.makeConstraints { make in
            make.height.equalTo(132)
        }
        siteTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        editProfileStackMain.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func convert(with profile: ProfileInfo) {
        nameTextField.text = profile.name
        bioTextField.text = profile.description
        siteTextField.text = profile.website
        if let avatarURLString = profileInfo?.avatar,
            let avatarURL = URL(string: avatarURLString) {
            updateAvatar(with: avatarURL, placeholder: nil, options: nil)
            profileImage.layer.cornerRadius = 35
            profileImage.layer.masksToBounds = true
        }
    }

    private func updateAvatar(
        with url: URL,
        placeholder: UIImage?,
        options: KingfisherOptionsInfo?
    ) {
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options)
    }

    @objc private func closeEditVCButtonTapped() {
        delegate?.editProfileVCDismissed(self)
    }
    
    @objc private func changeProfileImageButtonTapped() {
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor(named: "nftBlack")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
