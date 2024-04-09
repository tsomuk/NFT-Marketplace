//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Анастасия on 24.03.2024.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD

final class MyNFTViewController: UIViewController {

    // MARK: -  Properties & Constants
    
    private let servicesAssembly: ServicesAssembly
    private let networkClient = DefaultNetworkClient()
    private let profileInfo: ProfileInfo?
    private var myNFTs: [NFTInfo] = []
    private var myNFT: NFTInfo?

    private let emptyNFTLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("ProfileMyNFT.emptyNFTLabel", comment: "")
        label.textAlignment = .center
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(servicesAssembly: ServicesAssembly, profileInfo: ProfileInfo?) {
        self.servicesAssembly = servicesAssembly
        self.profileInfo = profileInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpNC()
        setUpView()
        fetchMyNFTInfo()
    }

    // MARK: -  Private Methods

    private func setUpNC() {
        title = NSLocalizedString("ProfileMyNFT.navbarTitle", comment: "")
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "nftBlack")
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(sortMyNFTButtonTapped))
        sortButton.tintColor = UIColor(named: "nftBlack")
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setUpView() {
        view.addSubview(myNFTTableView)
        view.addSubview(emptyNFTLabel)

        emptyNFTLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        myNFTTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        myNFTTableView.dataSource = self
        myNFTTableView.delegate = self
        myNFTTableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: "myNFTCell")

        myNFTTableView.isHidden = true
        emptyNFTLabel.isHidden = true
    }

    private func fetchMyNFTInfo() {
        setUpProgressHUD()
        ProgressHUD.show()

        guard let profileInfo = profileInfo else {
            print("Profile info is nil")
            ProgressHUD.dismiss()
            return
        }

        let nftIds = profileInfo.nfts
        for nftId in nftIds {
            networkClient.send(
                request: MyNFTInfoRequest(userId: "/api/v1/nft/", nftId: nftId),
                type: NFTInfo.self)
            { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let myNFTInfo):
                        self?.myNFTs.append(myNFTInfo)
                        self?.myNFTTableView.reloadData()
                        self?.updateUI()
                    case .failure(let error):
                        print("Failed to fetch profile info for NFT with ID \(nftId): \(error.localizedDescription)")
                    }
                }
            }
        }
        ProgressHUD.dismiss()
    }

    private func setUpProgressHUD() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorAnimation = UIColor(named: "nftBlack") ?? .black
        ProgressHUD.colorProgress = UIColor(named: "nftLightGray") ?? .lightGray
    }

    private func updateUI() {
        myNFTTableView.isHidden = myNFTs.isEmpty
        emptyNFTLabel.isHidden = !myNFTs.isEmpty
    }

    private func showDeleteAlert() {
        let alertModel = AlertModel(
            title: NSLocalizedString("ProfileMyNFT.sortAlertTitle", comment: ""),
            message: nil,
            primaryButton: AlertButton(
                buttonText: NSLocalizedString("ProfileMyNFT.priceAlertOption", comment: ""),
                completion: { [weak self] in
                    self?.sortMyNFT(by: .price)
                }
            ),
            additionalButtons: [
                AlertButton(
                    buttonText: NSLocalizedString("ProfileMyNFT.ratingAlertOption", comment: ""),
                    completion: { [weak self] in
                        self?.sortMyNFT(by: .rating)
                    }
                ),
                AlertButton(
                    buttonText: NSLocalizedString("ProfileMyNFT.nameAlertOption", comment: ""),
                    completion: { [weak self] in
                        self?.sortMyNFT(by: .name)
                    }
                ),
                AlertButton(
                    buttonText: NSLocalizedString("ProfileMyNFT.closeAlertOption", comment: ""),
                    completion: nil
                )
            ]
        )

        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }

    private func sortMyNFT(by sortOption: SortOptionMyNFT) {
        switch sortOption {
        case .price:
            myNFTs.sort { $0.price > $1.price }
        case .rating:
            myNFTs.sort { $0.rating > $1.rating }
        case .name:
            myNFTs.sort { $0.name < $1.name }
        }
        myNFTTableView.reloadData()
    }

    @objc private func sortMyNFTButtonTapped() {
        showDeleteAlert()
    }
}

// MARK: - UITableViewDataSource

extension MyNFTViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return myNFTs.count
    }

    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myNFTCell", for: indexPath) as? MyNFTTableViewCell else {
            fatalError("Unable to dequeue HabitCollectionViewCell")
        }
        cell.selectionStyle = .none
        let myNFT = myNFTs[indexPath.row]
        cell.configureMyNFT(with: myNFT)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyNFTViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 140.0
    }
}