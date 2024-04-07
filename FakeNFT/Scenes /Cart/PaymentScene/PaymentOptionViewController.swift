//
//  PaymentOptionViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//


import UIKit
import ProgressHUD

final class PaymentOptionViewController: UIViewController {
    
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
    private var currencyID = "" {
        didSet {
            payButton.alpha = 1
            payButton.isEnabled = true
        }
    }
    
    private var currencies : [Currency] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var payButton: UIButton = {
        let payButton = NFTButton(title: "Оплатить")
        payButton.alpha = 0.5
        payButton.isEnabled = false
        payButton.addTarget(self, action: #selector(goToPaymentResult), for: .touchUpInside)
        return payButton
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .nftLightGray
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return backgroundView
    }()
    
    private let userAgreementLabel = NFTTextLabel(
        text: "Совершая покупку, вы соглашаетесь с условиями",
        fontSize: 13,
        fontColor: .nftBlack,
        fontWeight: .regular
    )
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PaymentViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private lazy var userAgreementButton: UIButton = {
        let userAgreementButton = UIButton()
        userAgreementButton.setTitle("Пользовательского соглашения", for: .normal)
        userAgreementButton.setTitleColor(.nftBlue, for: .normal)
        userAgreementButton.titleLabel?.font = .systemFont(ofSize: 13)
        userAgreementButton.addTarget(self, action: #selector(showUserAgreement), for: .touchUpInside)
        return userAgreementButton
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [userAgreementLabel, userAgreementButton])
        vStack.axis = .vertical
        vStack.spacing = 0
        vStack.alignment = .leading
        return vStack
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        getCurrencyList()
    }
    
    // MARK: - Private methods
    
    @objc private func goToPaymentResult() {
        paymentConfirmationRequest(for: currencyID)
    }
    
    @objc private func showUserAgreement() {
        let webViewViewController = WebViewViewController()
        present(webViewViewController, animated: true)
    }
    
    private func setupAppearance() {
        title = "Выберите способ оплаты"
        view.backgroundColor = .nftWhite
        tabBarController?.tabBar.isHidden = true
        view.addSubviews(collectionView,backgroundView,payButton,vStack)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(backgroundView.snp.top)
        }
        
        vStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(payButton.snp_topMargin).offset(-16)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(186)
        }
        
        payButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    // MARK: - Alert
    
    private func showUnsuccessfulPaymentAlert() {
        
        let replayButton = AlertButton(buttonText: "Повторить") {
            self.paymentConfirmationRequest(for: self.currencyID)
        }
        
        let cancelButton = AlertButton(buttonText: "Отменить", completion: nil)
        
        let alertModel = AlertModel(
            title: "Не удалось произвести оплату",
            message: nil,
            primaryButton: replayButton,
            additionalButtons: [cancelButton]
        )
        
        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }
    
    // MARK: - Network
    
    private func getCurrencyList() {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        if !isLoading {
            isLoading = true
            servicesAssembly.nftService.loadCurrencyList { (result: Result<[Currency], Error>) in
                switch result {
                case .success(let currencies):
                    ProgressHUD.dismiss()
                    self.currencies = currencies
                case .failure:
                    ProgressHUD.showError()
                }
            }
            self.isLoading = false
        }
    }
    
    private func paymentConfirmationRequest(for id: String) {
        servicesAssembly.nftService.paymentConfirmationRequest(currencyId: id) {(result: Result<PaymentConfirmation, Error>) in
            switch result {
            case .success:
                let paymentResult = PaymentResultViewController(servicesAssembly: self.servicesAssembly)
                self.navigationController?.pushViewController(paymentResult, animated: true)
            case .failure:
                self.showUnsuccessfulPaymentAlert()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension PaymentOptionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PaymentViewCell else { return UICollectionViewCell() }
        let currency = currencies[indexPath.item]
        
        cell.configureCell(currency: currency)
        cell.backgroundColor = .nftLightGray
        cell.layer.cornerRadius = 12
        return cell
    }
}

extension PaymentOptionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentViewCell
        currencyID = currencies[indexPath.item].id
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 12
        cell?.layer.borderColor = UIColor.nftBlack.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentViewCell
        cell?.layer.borderWidth = 0
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentOptionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCount : CGFloat = 2
        let space: CGFloat = 7
        let width : CGFloat = (collectionView.bounds.width - space - 32) / itemCount
        let height : CGFloat = 46
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
    }
}
