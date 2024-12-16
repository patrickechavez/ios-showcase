//
//  QRCodeScannerViewModel.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import Foundation

class QRCodeScannerViewModel {
    private let coordinator: QRCodeScannerCoordinator?
    
    
    init(coordinator: QRCodeScannerCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("\(self) deallocated")
    }

}
