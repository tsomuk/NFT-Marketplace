//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 27.03.2024.
//


import UIKit
import WebKit
import ProgressHUD

class WebViewViewController: UIViewController {
    private let basicURL = "https://yandex.ru/legal/practicum_termsofuse/"
    
    private lazy var webview: WKWebView = {
        let webview = WKWebView()
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        makeRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showProgressHUD()
    }
    
    private func makeRequest() {
        guard let url = URL(string: basicURL) else { return }
        let request = URLRequest(url: url)
        webview.load(request)
    }
    
    private func showProgressHUD() {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.colorHUD = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            ProgressHUD.dismiss()
        }
    }
    
    private func setupAppearance() {
        view.addSubview(webview)
        
        webview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

