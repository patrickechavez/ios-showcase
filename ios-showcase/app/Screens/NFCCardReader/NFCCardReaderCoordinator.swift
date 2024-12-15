//
//  NFCCardReaderCoordinator.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit

class NFCCardReaderCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel                         = NFCCardReaderViewModel(coordinator: self)
        let nfcCardReaderViewController       = NFCCardReaderViewController()
        nfcCardReaderViewController.viewModel = viewModel
        navigationController.pushViewController(nfcCardReaderViewController, animated: true)
    }
}
