//
//  Alert.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/15/24.
//

import UIKit

struct AlertItem {
    let title: String
    let message: String
    let buttonTitle: String
    let secondaryButtonTitle: String?
    let secondaryButtonAction: (() -> Void)?
    
    init(
        title: String,
        message: String,
        buttonTitle: String,
        secondaryButtonTitle: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonAction = secondaryButtonAction
    }
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(
        title: "Invalid Device Input",
        message: "Something is wrong with the camera. We are unable to capture the input.",
        buttonTitle: "OK"
    )
    
    static let invalidScannedType = AlertItem(
        title: "Invalid Scan Type",
        message: "The value scanned is not valid. This app scans EAN-8 and EAN-13.",
        buttonTitle: "OK"
    )
    
    static let cameraAccessDenied = AlertItem(
        title: "Camera Access Denied",
        message: "Please allow camera access in Settings to use this feature.",
        buttonTitle: "Cancel",
        secondaryButtonTitle: "Settings",
        secondaryButtonAction: {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
    )
}
