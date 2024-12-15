//
//  AppCoordinator.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import Foundation

import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController { get set }
    func start()
    
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        FeatureList()
    }
    
    private func FeatureList() {
        let featureListCoordinator = FeatureListCoordinator(navigationController: self.navigationController)
        featureListCoordinator.start()
    }

}
