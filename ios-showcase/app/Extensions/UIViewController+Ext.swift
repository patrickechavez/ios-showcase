//
//  UIViewController+Ext.swift
//  GithubFollowers
//
//  Created by John Patrick Echavez on 8/21/22.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    /*
     * works in iOS 13
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    */
    
    func presentAlert(alertItem: AlertItem) {
        let alertController = UIAlertController(title: alertItem.title,
                                                message: alertItem.message,
                                                preferredStyle: .alert)
        
        // Primary action
        let primaryAction = UIAlertAction(title: alertItem.buttonTitle, style: .default, handler: nil)
        alertController.addAction(primaryAction)
        
        // Optional secondary action
        if let secondaryTitle = alertItem.secondaryButtonTitle, let secondaryAction = alertItem.secondaryButtonAction {
            let secondaryAlertAction = UIAlertAction(title: secondaryTitle, style: .default) { _ in
                secondaryAction()
            }
            alertController.addAction(secondaryAlertAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
     
    //In iOS 15, no need to use DispatchQueue.main.async {} code since UIViewControllers runs in @MainActor.
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = FTAlerViewController(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        self.present(alertVC, animated: true)
        
    }
    
    func presentDefaultError() {
        let alertVC = FTAlerViewController(title: "Something went wrong",
                                message: "We were unable to complete your task at this time. Please try again.",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    func presentSafariVC(url: URL) {
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    
}
