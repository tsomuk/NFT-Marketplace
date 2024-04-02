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
import ProgressHUD

protocol ProfileEditDelegate: AnyObject {
    func editProfileVCDismissed(_ vc: EditProfileViewController)
}

final class EditProfileViewController: UIViewController {
    
    // MARK: -  Properties & Constants

    private let servicesAssembly: ServicesAssembly
    private let networkClient = DefaultNetworkClient()
    private var profileInfo: ProfileInfo?
    private var newProfileInfo: ProfileInfo?
    weak var delegate: ProfileEditDelegate?
    
    private let shimmerLoaderViewName = ShimmerLoaderView()
    private let shimmerLoaderViewBio = ShimmerLoaderView()
    private let shimmerLoaderViewSite = ShimmerLoaderView()

    private lazy var closeEditVCButton: UIButton = {
        let button = UIButton(type: .system)
        let xmarkImage = UIImage(named: "close")
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

    private let downloadNewImageField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(named: "nftBlack")
        textField.placeholder = "Загрузить изображение"
        textField.textAlignment = .center
        textField.backgroundColor = UIColor(named: "nftLightGray")
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.layer.cornerRadius = 12
        return textField
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpView()
        setUpAnimation()
        fetchProfileInfoForEdit()
        dismissKeyboard()
    }

    // MARK: -  Private Methods

    private func setUpView() {
        [profileImage,
         changeProfileImageButton,
         editProfileStackMain,
         downloadNewImageField,
         shimmerLoaderViewName,
         shimmerLoaderViewBio,
         shimmerLoaderViewSite,
        ].forEach {
            view.addSubview($0)
        }

        navigationController?.view.addSubview(closeEditVCButton)

        closeEditVCButton.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.top.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().inset(16)
        }

        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(22)
            make.centerX.equalToSuperview()
        }
        changeProfileImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalTo(profileImage.snp.centerX)
            make.centerY.equalTo(profileImage.snp.centerY)
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
        downloadNewImageField.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(80)
            make.height.equalTo(35)
        }

        nameTextField.isUserInteractionEnabled = false
        bioTextField.isUserInteractionEnabled = false
        siteTextField.isUserInteractionEnabled = false
        changeProfileImageButton.isUserInteractionEnabled = false

        downloadNewImageField.isHidden = true

        nameTextField.delegate = self
        siteTextField.delegate = self
        downloadNewImageField.delegate = self
    }

    private func enableEditing() {
        nameTextField.isUserInteractionEnabled = true
        bioTextField.isUserInteractionEnabled = true
        siteTextField.isUserInteractionEnabled = true
        changeProfileImageButton.isUserInteractionEnabled = true
    }

    private func setUpAnimation() {
        shimmerLoaderViewName.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        shimmerLoaderViewBio.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(132)
        }
        shimmerLoaderViewSite.snp.makeConstraints { make in
            make.top.equalTo(siteLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        shimmerLoaderViewName.startShimmeringEffect()
        shimmerLoaderViewBio.startShimmeringEffect()
        shimmerLoaderViewSite.startShimmeringEffect()
    }

    private func stopAnimation() {
        shimmerLoaderViewName.stopShimmeringEffect()
        shimmerLoaderViewBio.stopShimmeringEffect()
        shimmerLoaderViewSite.stopShimmeringEffect()
        shimmerLoaderViewName.removeFromSuperview()
        shimmerLoaderViewBio.removeFromSuperview()
        shimmerLoaderViewSite.removeFromSuperview()
    }
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    private func fetchProfileInfoForEdit() {
        networkClient.send(
            request: ProfileInfoRequest(userId: "/api/v1/profile/1"),
            type: ProfileInfo.self)
        { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let profileInfo):
                    self?.profileInfo = profileInfo
                    self?.convert(with: profileInfo)
                    self?.enableEditing()
                case .failure(let error):
                    print("Failed to fetch profile info: \(error.localizedDescription)")
                }
            }
            self.stopAnimation()
        }
    }
    
    private func setUpProgressHUD() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorAnimation = UIColor(named: "nftBlack") ?? .black
        ProgressHUD.colorProgress = UIColor(named: "nftLightGray") ?? .lightGray
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

    // Creation of request object
    private func changeProfileData(with profile: ProfileInfo) {
        var avatarURL: String
        if downloadNewImageField.placeholder == "Загрузить изображение" {
            avatarURL = profile.avatar
        } else {
            avatarURL = downloadNewImageField.text ?? profile.avatar
        }

        newProfileInfo = ProfileInfo(
            name: nameTextField.text ?? "",
            avatar: avatarURL,
            description: bioTextField.text,
            website: siteTextField.text ?? "",
            nfts: profile.nfts,
            likes: profile.likes,
            id: profile.id)
    }

    private func updateNewProfileData() {
        setUpProgressHUD()
        ProgressHUD.show()
        
        guard let profileInfo = profileInfo
        else {
            print("Profile data is nil")
            ProgressHUD.dismiss()
            delegate?.editProfileVCDismissed(self)
            return
        }

        changeProfileData(with: profileInfo)

        guard let newProfileInfo = newProfileInfo
        else {
            print("New profile data is nil")
            ProgressHUD.dismiss()
            delegate?.editProfileVCDismissed(self)
            return
        }

        let updateRequest = ProfileUpdateRequest(userId: "/api/v1/profile/1", newProfileData: newProfileInfo)

        networkClient.send(
            request: updateRequest,
            type: ProfileInfo.self)
        { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedProfileInfo):
                    print("Profile successfully updated:", updatedProfileInfo)
                    ProgressHUD.dismiss()
                    self.delegate?.editProfileVCDismissed(self)
                case .failure(let error):
                    print("Failed to update profile:", error.localizedDescription)
                    ProgressHUD.dismiss()
                    self.delegate?.editProfileVCDismissed(self)
                }
            }
        }
    }

    @objc private func closeEditVCButtonTapped() {
        nameTextField.resignFirstResponder()
        siteTextField.resignFirstResponder()
        updateNewProfileData()
    }

    @objc private func changeProfileImageButtonTapped() {
        downloadNewImageField.isHidden = false
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
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
