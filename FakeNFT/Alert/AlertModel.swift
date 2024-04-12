//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Анастасия on 02.04.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let primaryButton: AlertButton
    let additionalButtons: [AlertButton]?
}

struct AlertButton {
    let buttonText: String
    let completion: (() -> Void)?
}
