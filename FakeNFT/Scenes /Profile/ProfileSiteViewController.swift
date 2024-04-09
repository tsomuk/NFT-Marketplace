//
//  ProfileSiteViewController.swift
//  FakeNFT
//
//  Created by Анастасия on 24.03.2024.
//

import Foundation
import UIKit
import WebKit

final class ProfileSiteViewController: UIViewController {

    // MARK: -  Properties & Constants
    
    private let servicesAssembly: ServicesAssembly
    private let networkClient = DefaultNetworkClient()
    private let profileInfo: ProfileInfo?
    private var estimatedProgressObservation: NSKeyValueObservation?

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(named: "nftBlack")
        return progressView
    }()

    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
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
        setUpView()
        setProgressView()

        if let profileInfo = profileInfo {
            loadWeb(with: profileInfo)
        }
    }

    // MARK: -  Private Methods

    private func setUpView() {
        view.addSubview(webView)
        view.addSubview(progressView)

        webView.snp.makeConstraints { make in
            make.top.trailing.bottom.leading.equalTo(view.safeAreaLayoutGuide)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func loadWeb(with profile: ProfileInfo) {
        let urlString = profile.website
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        webView.navigationDelegate = self
    }

    private func setProgressView() {
        progressView.progress = 0.1
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [.new],
             changeHandler: { [weak self] webView, _ in
                 guard let self = self else { return }
                 self.progressView.progress = Float(webView.estimatedProgress)
             })
    }
}

extension ProfileSiteViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!)
    {
        progressView.isHidden = true
    }
}
