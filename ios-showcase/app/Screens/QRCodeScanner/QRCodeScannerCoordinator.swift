//
//  QRCodeScannerCoordinator.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit

class QRCodeScannerCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel                            = QRCodeScannerViewModel(coordinator: self)
        let qrCodeScannerViewController          = QRCodeScannerViewController()
        qrCodeScannerViewController.viewModel    = viewModel
        navigationController.pushViewController(qrCodeScannerViewController, animated: true)
    }
}
