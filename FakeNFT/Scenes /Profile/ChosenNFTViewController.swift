//
//  ChosenNFTViewController.swift
//  FakeNFT
//
//  Created by Анастасия on 24.03.2024.
//

import Foundation
import UIKit

final class ChosenNFTViewController: UIViewController {

    // MARK: -  Properties & Constants
    private var myChosenNFTs: [NFTInfo] = []
    private var myChosenNFT: NFTInfo?

    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 7)

    private let emptyNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет избранных NFT"
        label.textAlignment = .center
        label.textColor = UIColor(named: "nftBlack")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private var myChosenNFTCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Избранные NFT"
        setUpView()

        let mockNFT1 = NFTInfo(
            createdAt: "",
            name: "April",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 5,
            description: "I'm the best",
            price: 1.25,
            author: "Dina Doe",
            id: "1"
        )
        let mockNFT2 = NFTInfo(
            createdAt: "",
            name: "Bella",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 2,
            description: "I'm the best",
            price: 1.05,
            author: "John Doe",
            id: "2"
        )
        let mockNFT3 = NFTInfo(
            createdAt: "",
            name: "Cita",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 4,
            description: "I'm the best",
            price: 3.00,
            author: "Justin Doe",
            id: "3"
        )
        myChosenNFTs = [mockNFT1, mockNFT2, mockNFT3]
        updateUI()
    }

    // MARK: -  Private Methods

    private func setUpView() {
        view.addSubview(myChosenNFTCollView)
        view.addSubview(emptyNFTLabel)

        myChosenNFTCollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(emptyNFTLabel.snp.top).offset(-20)
        }
        emptyNFTLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        myChosenNFTCollView.dataSource = self
        myChosenNFTCollView.delegate = self
        myChosenNFTCollView.register(
            ChosenNFTViewCell.self,
            forCellWithReuseIdentifier: "cellChosenNFTCV")

        myChosenNFTCollView.isHidden = true
        emptyNFTLabel.isHidden = true
    }

    private func updateUI() {
        myChosenNFTCollView.isHidden = myChosenNFTs.isEmpty
        emptyNFTLabel.isHidden = !myChosenNFTs.isEmpty
    }
}
// MARK: - UICollectionViewDataSource

extension ChosenNFTViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return myChosenNFTs.count
    }

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cellChosenNFTCV",
            for: indexPath) as? ChosenNFTViewCell
        else { return UICollectionViewCell() }
        
        let myChosenNFT = myChosenNFTs[indexPath.row]
        cell.configureMyChosenNFT(with: myChosenNFT)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChosenNFTViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 80)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: params.leftInset,
            bottom: 0,
            right: params.rightInset)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 20
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }
}
