//
//  PaymentResultViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//

import UIKit
import ProgressHUD

final class PaymentResultViewController: UIViewController {

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

    private lazy var payButton: UIButton = {
        let payButton = NFTButton(title: "Cart.goToCatalog"~)
        payButton.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
        return payButton
    }()

    private lazy var holderImage: UIImageView = {
        let holderImage = UIImageView()
        holderImage.image = UIImage(named: "paymentHolder")
        holderImage.contentMode = .scaleAspectFit
        return holderImage
    }()

    private let paymentLabel = NFTTextLabel(
        text: "Cart.paymentPassed"~,
        fontSize: 22,
        fontColor: .nftBlack,
        fontWeight: .bold
    )

    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [holderImage, paymentLabel])
        vStack.axis = .vertical
        vStack.spacing = 20
        return vStack
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }

    // MARK: - Private methods

    @objc private func backToCatalog() {
        cleanCard()
    }

    private func cleanCard() {
        self.servicesAssembly.nftService.updateOrder(nftsIds: [], isPaymentDone: true) { (result: Result<Order, Error>) in
            switch result {
            case .success:
                self.tabBarController?.selectedIndex = 1
                self.navigationController?.popToRootViewController(animated: true)
            case .failure:
                ProgressHUD.showError()
            }
        }
    }

    private func setupAppearance() {

        view.backgroundColor = .nftWhite

        paymentLabel.numberOfLines = 2
        paymentLabel.textAlignment = .center

        navigationController?.setNavigationBarHidden(true, animated: true)

        view.addSubviews(payButton, vStack)

        vStack.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(36)
        }

        holderImage.snp.makeConstraints { make in
            make.height.equalTo(278)
        }

        payButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}
