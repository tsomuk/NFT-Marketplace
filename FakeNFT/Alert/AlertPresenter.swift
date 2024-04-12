//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Анастасия on 02.04.2024.
//

import Foundation
import UIKit

final class AlertPresenter {
    static func showAlert(alertModel: AlertModel, delegate: UIViewController, preferredStyle: UIAlertController.Style ) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: preferredStyle)
        
        alert.view.accessibilityIdentifier = "Alert"

        // Добавление основной кнопки
        let primaryAction = UIAlertAction(title: alertModel.primaryButton.buttonText, style: .default) { _ in
            alertModel.primaryButton.completion?()
        }
        alert.addAction(primaryAction)

        // Добавление дополнительных кнопок, если они есть
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
