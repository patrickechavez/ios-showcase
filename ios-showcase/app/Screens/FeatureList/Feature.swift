//
//  Feature.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/13/24.
//

import Foundation
import UIKit

struct Feature: Codable, Hashable {
    let id: UUID
    let iconName: String
    let featureName: String
    let screen: Screen
    
    static let mockData: [Feature] = [
        Feature(id: UUID(), iconName: "qrcode.viewfinder", featureName: "QR Code Scanner", screen: .qrCodeScanner),
        Feature(id: UUID(), iconName: "barcode.viewfinder", featureName: "Barcode Scanner", screen: .barCodeScanner),
        Feature(id: UUID(), iconName: "wave.3.left.circle.fill", featureName: "NFC Card Reader", screen: .nfcReader)
    ]
    func getCoordinator() -> Coordinator {
        
        switch screen {
        case .qrCodeScanner:
            return QRCodeScannerCoordinator(navigationController: UINavigationController())
        case .barCodeScanner:
            return BarcodeScannerCoordinator(navigationController: UINavigationController())
        case .nfcReader:
            return NFCCardReaderCoordinator(navigationController: UINavigationController())
        }
    }
}
