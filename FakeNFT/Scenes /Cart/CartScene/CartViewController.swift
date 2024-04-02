//
//  ViewController.swift
//  NFT_Donor
//
//  Created by Nikita Tsomuk on 23.03.2024.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {

    // MARK: - ServicesAssembly

    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private varibles
    
    private var isLoading = false

    private var nftOrder: Order? = nil {
        didSet {
            getNfts(nftOrder?.nfts ?? [])
        }
    }

    private var nfts: [Nft] = [] {
        didSet {
            tableView.reloadData()
            updateHolders()
            numOfElementsLabel.text = "\(nfts.count) NFT"
            totalPriceLabel.text = calculateCart()
        }
    }

    private lazy var payButton: UIButton = {
        let payButton = NFTButton(title: "К оплате")
        payButton.addTarget(self, action: #selector(goToPayment), for: .touchUpInside)
        return payButton
    }()

    private lazy var numOfElementsLabel: UILabel = {
        let numOfElementsLabel = NFTTextLabel(text: "", fontSize: 15, fontColor: .nftBlack, fontWeight: .regular)
        return numOfElementsLabel
    }()

    private lazy var totalPriceLabel: UILabel = {
        let totalPriceLabel = NFTTextLabel(text: "", fontSize: 17, fontColor: .nftGreen, fontWeight: .bold)
        return totalPriceLabel
    }()

    private let holderLabel = NFTTextLabel(text: "Корзина пуста", fontSize: 17, fontColor: .nftBlack, fontWeight: .bold)

    private lazy var priceVStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [numOfElementsLabel, totalPriceLabel])
        vStack.axis = .vertical
        vStack.spacing = 2
        return vStack
    }()

    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .nftLightGray
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return backgroundView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.rowHeight = 140
        tableView.backgroundColor = .nftWhite
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupNavBar()
        updateHolders()

        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        getOrder()
    }

    // MARK: - Private methods
    
    private func setupNavBar() {
        let sortButton = UIBarButtonItem(image: .sort, style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton.tintColor = .nftBlack
        navigationItem.rightBarButtonItem = sortButton
    }

    private func getOrder() {
        if !isLoading {
            isLoading = true
            servicesAssembly.nftService.loadOrder { (result: Result<Order, Error>) in
                switch result {
                case .success(let order):
                    self.isLoading = false
                    self.nftOrder = order
                case .failure(let error):
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func getNfts(_ ids: [String]) {
        if !isLoading {
            isLoading = true
            for id in ids {
                servicesAssembly.nftService.loadNft(id: id) { (result: Result<Nft, Error>) in
                    switch result {
                    case .success(let nft):
                        self.isLoading = false
                        self.nfts.isEmpty ? self.nfts.append(nft) : self.apppendNewNft(nft)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    private func apppendNewNft(_ nft: Nft) {
        if nfts.filter({ $0.id == nft.id}).count == 0 {
            nfts.append(nft)
        }
    }

    private func calculateCart() -> String {
        var sum : Float = 0
        for nft in nfts {
            sum += nft.price
        }
        return String(format: "%.2f", sum) + " ETN"
    }

    private func updateHolders() {
        tableView.isHidden = nfts.isEmpty
        payButton.isHidden = nfts.isEmpty
        priceVStack.isHidden = nfts.isEmpty
        backgroundView.isHidden = nfts.isEmpty
        holderLabel.isHidden = !nfts.isEmpty
    }

    private func setupAppearance() {
        view.backgroundColor = .nftWhite

        view.addSubviews(tableView,backgroundView,payButton,holderLabel,priceVStack)

        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(76)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(backgroundView.snp_topMargin)
        }

        holderLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }

        payButton.snp.makeConstraints { make in
            make.leading.equalTo(priceVStack.snp.trailing).offset(24)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }

        priceVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    @objc private func goToPayment() {
        let paymentViewController = PaymentOptionViewController()
        navigationController?.pushViewController(paymentViewController, animated: true)
        navigationController?.navigationBar.tintColor = .nftBlack
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Action Sheet

    @objc private func sortButtonTapped() {

        let actionSheet = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        let priceSort = UIAlertAction(title: "По цене", style: .default) { _ in
            // TODO: Add price sort
        }

        let ratingSort = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            // TODO: Add rating sort
        }

        let titleSort = UIAlertAction(title: "По названию", style: .default) { _ in
            // TODO: Add name sort
        }

        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
        }
        
        [priceSort,ratingSort,titleSort,cancelAction].forEach { actionSheet.addAction($0)}
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - TableView Datasouce

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        let nft = nfts[indexPath.row]
        cell.configCell(data: nft)
        cell.backgroundColor = .clear
        return cell
    }
}

//  MARK: - Additional files (Temperary)

// MARK: - Color+extension

extension UIColor {
    static var nftBlack: UIColor { UIColor(named: "nftBlack") ?? UIColor.black }
    static var nftGreen: UIColor { UIColor(named: "nftGreen") ?? UIColor.green }
    static var nftRed: UIColor { UIColor(named: "nftRed") ?? UIColor.red }
    static var nftBlue: UIColor { UIColor(named: "nftBlue") ?? UIColor.blue }
    static var nftYellow: UIColor { UIColor(named: "nftYellow") ?? UIColor.yellow }
    static var nftGray: UIColor { UIColor(named: "nftGray") ?? UIColor.darkGray }
    static var nftLightGray: UIColor { UIColor(named: "nftLightGray") ?? UIColor.gray }
    static var nftWhite: UIColor { UIColor(named: "nftWhite") ?? UIColor.white }
}

// MARK: - Images+extension

extension UIImage {
    //images
    static var mockNft = UIImage(named: "mockNft") ?? UIImage()
    //icons
    static var basketDelete = UIImage(named: "basketDelete") ?? UIImage()
    static var basketEmpty = UIImage(named: "basketEmpty") ?? UIImage()
    static var basketFill = UIImage(named: "basketFill") ?? UIImage()
    static var sort = UIImage(named: "sort") ?? UIImage()
    static var done = UIImage(named: "Done") ?? UIImage()
    static var close = UIImage(named: "close") ?? UIImage()
}

// MARK: - View+extension

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}

// MARK: - Custom UI Elements

final class NFTButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = .nftBlack
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.setTitleColor(.nftWhite, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class NFTTextLabel: UILabel {
    init(text: String,fontSize: CGFloat, fontColor: UIColor, fontWeight: UIFont.Weight) {
        super.init(frame: .zero)
        self.text = text
        self.numberOfLines = 0
        self.textColor = fontColor
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
