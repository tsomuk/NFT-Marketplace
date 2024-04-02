//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Анастасия on 24.03.2024.
//

import Foundation
import UIKit
import SnapKit

final class MyNFTViewController: UIViewController {

    // MARK: -  Properties & Constants

    private var myNFTs: [NFTInfo] = []
    private var myNFT: NFTInfo?

    private let emptyNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет NFT"
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpNC()
        setUpView()
        let mockNFT1 = NFTInfo(
            createdAt: "2023-04-20T02:22:27Z",
            name: "Lila",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 3,
            description: "I'm the best",
            price: 1.75,
            author: "Dina Doe",
            id: "1"
        )
        let mockNFT2 = NFTInfo(
            createdAt: "2023-04-20T02:22:27Z",
            name: "Pip",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 5,
            description: "I'm the best",
            price: 0.75,
            author: "John Doe",
            id: "2"
        )
        let mockNFT3 = NFTInfo(
            createdAt: "2023-04-20T02:22:27Z",
            name: "Tita",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 4,
            description: "I'm the best",
            price: 2.75,
            author: "Justin Doe",
            id: "3"
        )
    myNFTs = [mockNFT1, mockNFT2, mockNFT3]

        updateUI()
    }

    // MARK: -  Private Methods

    private func setUpNC() {
        title = "Мои NFT"
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
            make.height.equalTo(140)
        }

        myNFTTableView.dataSource = self
        myNFTTableView.delegate = self
        myNFTTableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: "myNFTCell")

        myNFTTableView.isHidden = true
        emptyNFTLabel.isHidden = true
    }

    private func updateUI() {
        if myNFTs.isEmpty {
            myNFTTableView.isHidden = true
            emptyNFTLabel.isHidden = false
        } else {
            myNFTTableView.isHidden = false
            emptyNFTLabel.isHidden = true
        }
    }

    private func showDeleteAlert() {
        let alertModel = AlertModel(
            title: "Сортировка",
            message: nil,
            primaryButton: AlertButton(
                buttonText: "По цене",
                completion: { [weak self] in
                    self?.sortMyNFT(by: .price)
                }
            ),
            additionalButtons: [
                AlertButton(
                    buttonText: "По рейтингу",
                    completion: { [weak self] in
                        self?.sortMyNFT(by: .rating)
                    }
                ),
                AlertButton(
                    buttonText: "По названию",
                    completion: { [weak self] in
                        self?.sortMyNFT(by: .name)
                    }
                ),
                AlertButton(
                    buttonText: "Закрыть",
                    completion: nil
                )
            ]
        )

        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }

    private func sortMyNFT(by sortOption: SortOptionMyNFT) {
        switch sortOption {
        case .price:
            myNFTs.sort { $0.price < $1.price }
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

struct NFTInfo: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}

enum SortOptionMyNFT {
    case price
    case rating
    case name
}
