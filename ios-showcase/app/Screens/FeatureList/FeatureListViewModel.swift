//
//  FeatureListViewModel.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import Foundation

class FeatureListViewModel {
    private let coordinator: FeatureListCoordinator
    
    
    init(coordinator: FeatureListCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigatetoSelectedFeature(selectedFeature: Feature) {
        coordinator.navigateToSelectedFeature(selectedFeature: selectedFeature)
    }
    
}
