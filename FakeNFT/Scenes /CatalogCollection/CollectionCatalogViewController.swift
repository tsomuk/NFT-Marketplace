//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Арина Колганова on 06.04.2024.
//

import Kingfisher
import ProgressHUD
import UIKit

final class CatalogCollectionViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly
    private let catalogCollection: CatalogCollection

    private var allCollections: [CatalogCollection] = []

    private lazy var scrollView: UIScrollView = .init()

    private lazy var imageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        guard let urlString = catalogCollection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            return imageView
        }
        imageView.kf.setImage(with: url)
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text =  catalogCollection.name
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var textView: UITextView = {
        let text = UITextView()
        let attributedString = NSMutableAttributedString(string: catalogCollection.author)
        let url = URL(string: RequestConstants.ypURL)!
        attributedString.setAttributes([.link: url], range: NSRange(location: 0, length: attributedString.length))
        text.isScrollEnabled = false
        text.attributedText = attributedString
        text.isUserInteractionEnabled = true
        text.isEditable = false
        text.font = .systemFont(ofSize: 15, weight: .regular)
        text.delegate = self
        return text
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = catalogCollection.description
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .background
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.register(NFTCatalogCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCatalogCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    init(servicesAssembly: ServicesAssembly, catalogCollection: CatalogCollection) {
        self.servicesAssembly = servicesAssembly
        self.catalogCollection = catalogCollection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let ratio = (imageView.image?.size.width ?? 1) / (imageView.image?.size.height ?? 1)
        let newHeight = UIScreen.main.bounds.width / ratio

        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview()
            $0.height.equalTo(newHeight)
        }

        scrollView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalTo(view).inset(9)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(9)
            $0.height.width.equalTo(24)
        }
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(imageView.snp.bottom).offset(16)
        }

        scrollView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(nameLabel.snp.bottom).offset(13)
            $0.width.equalTo(112)
        }

        scrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(authorLabel.snp.bottom).offset(4)
        }

        scrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
        }

        scrollView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.leading.equalTo(authorLabel.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(descriptionLabel.snp.top)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

extension CatalogCollectionViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        let webVC = WebViewController(url: RequestConstants.ypURL)
        webVC.modalPresentationStyle = .fullScreen
        present(webVC, animated: false)
        return false
    }
}

extension CatalogCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catalogCollection.nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NFTCatalogCell", for: indexPath
        ) as? NFTCatalogCollectionViewCell else {
            return UICollectionViewCell()
        }

        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: NFTCatalogCollectionViewCell, indexPath: IndexPath) {
        cell.startAnimation()
        servicesAssembly.nftService.loadNft(
            id: catalogCollection.nfts[indexPath.row]
        ) { (result: Result<Nft, Error>) in
            switch result {
            case .success(let nft):
                DispatchQueue.main.async {
                    cell.configure(nft: nft)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        cell.stopAnimation()
    }
 }

extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 20
        let cellWidth =  availableWidth / 3
        return CGSize(width: cellWidth, height: 192)
    }
}
