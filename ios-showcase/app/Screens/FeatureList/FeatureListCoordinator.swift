//
//  FeatureListCoordinator.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit

class FeatureListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel                         = FeatureListViewModel(coordinator: self)
        let featureListViewController         = FeatureListViewController()
        featureListViewController.viewModel   = viewModel
        navigationController.pushViewController(featureListViewController, animated: true)
    }
    
    func navigateToSelectedFeature(selectedFeature: Feature) {
        
        var selectedFeatureCoordinator: Coordinator?
        switch selectedFeature.screen {
        case .qrCodeScanner:
            selectedFeatureCoordinator = QRCodeScannerCoordinator(navigationController: navigationController)
        case .barCodeScanner:
            selectedFeatureCoordinator = BarcodeScannerCoordinator(navigationController: navigationController)
        case .nfcReader:
            selectedFeatureCoordinator = NFCCardReaderCoordinator(navigationController: navigationController)
        }
        selectedFeatureCoordinator?.start()

    }

}
