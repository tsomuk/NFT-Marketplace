//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 22.03.2024.
//

import UIKit
import Kingfisher
import SnapKit

final class ProfileViewController: UIViewController {

    // MARK: -  Properties & Constants

    private let servicesAssembly: ServicesAssembly
    private let networkClient = DefaultNetworkClient()
    private var numberOfMyNFT = 0
    private var numberOfChosenNFT = 0
    private var profileInfo: ProfileInfo?
    
    private let shimmerLoaderViewName = ShimmerLoaderView()
    private let shimmerLoaderView = ShimmerLoaderView()

    private lazy var profileMainInfoStack1: UIStackView = {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            profileImage,
            profileNameLabel
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 16
        horizontalStackView.alignment = .center
        return horizontalStackView
    }()

    private lazy var profileMainInfoStack2: UIStackView = {
        let verticalStackView = UIStackView(arrangedSubviews: [
            profileMainInfoStack1,
            profileBioLabel
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 20
        verticalStackView.alignment = .leading
        return verticalStackView
    }()

    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = UIColor(named: "nftBlack")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let profileBioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .left
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()

    private lazy var profileSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "",
            for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        let nftBlue = UIColor(named: "nftBlue")
        button.setTitleColor(nftBlue, for: .normal)
        button.addTarget(
            self,
            action: #selector(profileSiteButtonTapped),
            for: .touchUpInside)
        return button
    }()

    private var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
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
        addNCViews()
        setUpView()
        setUpAnimation()
        fetchProfileInfo()
    }

    // MARK: -  Private Methods

    private func addNCViews() {
        if navigationController != nil {
            let editButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .plain,
                target: self,
                action: #selector(editProfileButtonTapped))
            editButton.tintColor = UIColor(named: "nftBlack")
            navigationItem.rightBarButtonItem = editButton
        }
    }

    private func setUpView() {
        [profileMainInfoStack2,
         profileSiteButton,
         profileTableView,
         shimmerLoaderViewName,
         shimmerLoaderView
        ].forEach {
             view.addSubview($0)
        }

        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
        }
        profileMainInfoStack2.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        profileSiteButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(profileMainInfoStack2.snp.bottom).offset(8)
        }
        profileTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(profileSiteButton.snp.bottom).offset(40)
            make.height.equalTo(162)
        }

        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "profileCell")
        profileTableView.isScrollEnabled = false
    }

    private func setUpAnimation() {
        shimmerLoaderViewName.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.trailing.equalTo(profileMainInfoStack2)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.height.equalTo(50)
        }
        shimmerLoaderView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(profileMainInfoStack2)
            make.top.equalTo(profileMainInfoStack1.snp.bottom).offset(20)
            make.height.equalTo(300)
        }

        shimmerLoaderViewName.startShimmeringEffect()
        shimmerLoaderView.startShimmeringEffect()
    }
    
    private func stopAnimation() {
        shimmerLoaderViewName.stopShimmeringEffect()
        shimmerLoaderView.stopShimmeringEffect()
        shimmerLoaderViewName.removeFromSuperview()
        shimmerLoaderView.removeFromSuperview()
    }

    private func fetchProfileInfo() {
        networkClient.send(
            request: ProfileInfoRequest(userId: "/api/v1/profile/1"),
            type: ProfileInfo.self)
        { result in
            DispatchQueue.main.async { [weak self] in
                   switch result {
                       case .success(let profileInfo):
                           self?.profileInfo = profileInfo
                           self?.convert(with: profileInfo)
                           self?.stopAnimation()
                       case .failure(let error):
                           print("Failed to fetch profile info: \(error.localizedDescription)")
                   }
               }
            self.stopAnimation()
        }
    }

    private func convert(with profile: ProfileInfo) {
        profileNameLabel.text = profile.name
        profileBioLabel.text = profile.description
        if let avatarURLString = profileInfo?.avatar,
            let avatarURL = URL(string: avatarURLString) {
            updateAvatar(with: avatarURL, placeholder: nil, options: nil)
            profileImage.layer.cornerRadius = 35
            profileImage.layer.masksToBounds = true
        }
        profileSiteButton.setTitle(profile.website, for: .normal)
        numberOfMyNFT = profile.nfts.count
        numberOfChosenNFT = profile.likes.count
        profileTableView.reloadData()
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

    @objc private func editProfileButtonTapped() {
        let editPrifileVC = EditProfileViewController(servicesAssembly: servicesAssembly)
        editPrifileVC.delegate = self
        let editPrifileNC = UINavigationController(rootViewController: editPrifileVC)
        present(editPrifileNC, animated: true, completion: nil)
    }

    @objc private func profileSiteButtonTapped() {
        if let navigationController = self.navigationController {
            let profileSiteVC = ProfileSiteViewController()
            navigationController.pushViewController(profileSiteVC, animated: true)
        }
        navBarBackButton()
    }
}

// MARK: - ProfileEdutDelegate - dismiss EditProfileVC

extension ProfileViewController: ProfileEditDelegate {
    func editProfileVCDismissed(_ vc: EditProfileViewController) {
        fetchProfileInfo()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 3
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell else {
            fatalError("Unable to dequeue HabitCollectionViewCell")
        }

        cell.tintColor = UIColor(named: "nftBlack")
        cell.selectionStyle = .none

        switch indexPath.section {
        case 0:
            cell.setTitleLabel(text: "Мои NFT (\(numberOfMyNFT))")
        case 1:
            cell.setTitleLabel(text: "Избранные NFT (\(numberOfChosenNFT))")
        case 2:
            cell.setTitleLabel(text: "О разработчике")
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            showMyNFTScreen()
        case 1:
            showChosenScreen()
        case 2:
            profileSiteButtonTapped()
        default:
            break
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 54.0
    }

    private func showMyNFTScreen() {
        if let navigationController = self.navigationController {
            let myNFTVC = MyNFTViewController()
            navigationController.pushViewController(myNFTVC, animated: true)
            navBarBackButton()
        }
    }

    private func showChosenScreen() {
        if let navigationController = self.navigationController {
            let chosenNFTVC = ChosenNFTViewController()
            navigationController.pushViewController(chosenNFTVC, animated: true)
            navBarBackButton()
        }
    }

    private func navBarBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "nftBlack")
    }
}
