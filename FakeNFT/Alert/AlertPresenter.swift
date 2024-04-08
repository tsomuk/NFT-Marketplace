//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 07.04.2024.
//

import Foundation
import UIKit

final class AlertPresenter {
    static func showAlert(alertModel: AlertModel, delegate: UIViewController) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let primaryAction = UIAlertAction(title: alertModel.primaryButton.buttonText, style: .default) { _ in
            alertModel.primaryButton.completion?()
        }
        alert.addAction(primaryAction)


        if let additionalButtons = alertModel.additionalButtons {
            for (index, button) in additionalButtons.enumerated() {
                let style: UIAlertAction.Style = index == additionalButtons.count - 1 ? .cancel : .default
                let additionalAction = UIAlertAction(title: button.buttonText, style: style) { _ in
                    button.completion?()
                }
                alert.addAction(additionalAction)
            }
        }

        delegate.present(alert, animated: true, completion: nil)
    }
}
