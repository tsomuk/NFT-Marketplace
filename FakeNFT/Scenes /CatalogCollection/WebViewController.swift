//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Арина Колганова on 07.04.2024.
//

import UIKit

final class WebViewController: UIViewController {
    private let url: String

    private lazy var webView: UIWebView = .init()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let urlRequest = URL(string: url) else { return }
        webView.loadRequest(URLRequest(url: urlRequest))
        view.backgroundColor = .systemBackground

        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalTo(view).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(backButton.snp.bottom).offset(9)
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
