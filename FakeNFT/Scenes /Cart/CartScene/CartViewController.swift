//
//  ViewController.swift
//  NFT_Donor
//
//  Created by Nikita Tsomuk on 23.03.2024.
//

import UIKit
import SnapKit
import ProgressHUD

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
            nftOrder?.nfts.isEmpty ?? true ? nfts.removeAll() : getNfts(nftOrder?.nfts ?? [])
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
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        getOrder()
    }

    // MARK: - Private methods
    
    private func setupNavBar() {
        let sortButton = UIBarButtonItem(image: .sort, style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton.tintColor = .nftBlack
        navigationItem.rightBarButtonItem = sortButton
    }

    // MARK: - Network
    
    private func getOrder() {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        if !isLoading {
            isLoading = true
            servicesAssembly.nftService.loadOrder { (result: Result<Order, Error>) in
                switch result {
                case .success(let order):
                    ProgressHUD.dismiss()
                    self.nftOrder = order
                case .failure(let error):
                    ProgressHUD.showError()
                    print(error.localizedDescription)
                }
            }
            self.isLoading = false
        }
    }

    private func getNfts(_ ids: [String]) {
        if !isLoading {
            isLoading = true
            for id in ids {
                servicesAssembly.nftService.loadNft(id: id) { (result: Result<Nft, Error>) in
                    switch result {
                    case .success(let nft):
                        self.nfts.isEmpty ? self.nfts.append(nft) : self.apppendNewNft(nft)
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                }
                self.isLoading = false
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

    // MARK: - Move to the next screen
    
    @objc private func goToPayment() {
        let paymentViewController = PaymentOptionViewController(servicesAssembly: servicesAssembly)
        navigationController?.pushViewController(paymentViewController, animated: true)
        navigationController?.navigationBar.tintColor = .nftBlack
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Action Sheet

    @objc private func sortButtonTapped() {

        let actionSheet = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        let priceSort = UIAlertAction(title: "По цене", style: .default) { _ in
            self.nfts.sort { $0.price > $1.price }
        }

        let ratingSort = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.nfts.sort { $0.rating > $1.rating }
        }

        let titleSort = UIAlertAction(title: "По названию", style: .default) { _ in
            self.nfts.sort { $0.name < $1.name }
        }

        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
        }
        
        self.tableView.reloadData()
        [priceSort,ratingSort,titleSort,cancelAction].forEach { actionSheet.addAction($0) }
        self.present(actionSheet, animated: true, completion: nil)
    }
}

    // MARK: - TableView Datasouce

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        let nft = nfts[indexPath.row]
        cell.configCell(data: nft)
        cell.delegate = self
        cell.backgroundColor = .clear
        return cell
    }
}

    // MARK: - DeleteNftDelegate

extension CartViewController: DeleteNftDelegate {
    func deleteNft(id: String, image: UIImage) {
        let deleteViewController = DeleteViewController(image: image) {
            self.nfts.removeAll { $0.id == id }
            let newIds = self.nfts.map { $0.id }
            self.servicesAssembly.nftService.updateOrder(nftsIds: newIds, isPaymentDone: false) { (result: Result<Order, Error>) in
                switch result {
                case .success(let order):
                    self.nftOrder = order
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        deleteViewController.modalPresentationStyle = .overFullScreen
        present(deleteViewController, animated: false) {
            UIView.animate(withDuration: 0.3) {
                deleteViewController.view.alpha = 1
            }
        }
    }
}
