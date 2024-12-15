//
//  BarcodeScannerViewController.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController {

    let barcodeCameraViewController = BarcodeCameraViewController()
    let stackView = UIStackView()
    let iconImageView = UIImageView()
    let scannedBarcodeLabel = UILabel()
    var scannedBarCode = UILabel()
    let scanButton = FTButton(backgroundColor: .blue, title: "Scan Again?")
    
    var viewModel: BarcodeScannerViewModel!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCameraPreview()
        configurescannedBarcodeLabel()
        configureBarcodeText()
        configureScanButton()

    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Barcode Scanner"
    }
    
    private func configureCameraPreview() {
        addChild(barcodeCameraViewController)
        barcodeCameraViewController.delegate = self
        barcodeCameraViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(barcodeCameraViewController.view)
        NSLayoutConstraint.activate([
            barcodeCameraViewController.view.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -70),
            barcodeCameraViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            barcodeCameraViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            barcodeCameraViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        
        barcodeCameraViewController.didMove(toParent: self)
    }
    
    func configurescannedBarcodeLabel() {
        view.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        iconImageView.image = UIImage(systemName: "barcode.viewfinder")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .label
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        scannedBarcodeLabel.text = "Scanned Bar Code:"
        scannedBarcodeLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        scannedBarcodeLabel.textColor = .label
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: barcodeCameraViewController.view.bottomAnchor, constant: 12),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(scannedBarcodeLabel)
    }
    
    func configureBarcodeText() {
        view.addSubview(scannedBarCode)
        
        scannedBarCode.text = "Not Yet Scanned"
        scannedBarCode.font = UIFont.boldSystemFont(ofSize: 36)
        scannedBarCode.textColor = .red
        scannedBarCode.textAlignment = .center
        scannedBarCode.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scannedBarCode.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            scannedBarCode.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scannedBarCode.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    
    func configureScanButton() {
        view.addSubview(scanButton)
        scanButton.isHidden = true
        
        scanButton.addTarget(self, action: #selector(scanAgainPressed), for: .touchUpInside)
        
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scanButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func scanAgainPressed() {
        DispatchQueue.main.async { [weak self] in
            self?.scannedBarCode.textColor = .red
            self?.scannedBarCode.text = "Not Yet Scanned"
            self?.scanButton.isHidden = true
            self?.barcodeCameraViewController.restartScanning()
        }
    }

}

extension BarcodeScannerViewController: CameraViewControllerDelegate {
    func didCaptureBarcode(_ barcode: String) {
        
        DispatchQueue.main.async { [weak self] in
            self?.scannedBarCode.textColor = .green
            self?.scannedBarCode.text = barcode
            self?.scanButton.isHidden = false
        }
    }
    
    
}

@available(iOS 17, *)
#Preview {
    BarcodeScannerViewController()
}

