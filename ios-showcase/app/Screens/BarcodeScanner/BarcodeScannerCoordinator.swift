//
//  BarcodeScannerCoordinator.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit

class BarcodeScannerCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel                          =  BarcodeScannerViewModel(coordinator: self)
        let barcodeScannerViewController       = BarcodeScannerViewController()
        barcodeScannerViewController.viewModel = viewModel
        navigationController.pushViewController(barcodeScannerViewController, animated: true)
    }
    
    deinit {
        print("\(self) deallocated")
    }
}
