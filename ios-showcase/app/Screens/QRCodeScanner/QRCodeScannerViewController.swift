//
//  QRCodeScannerViewController.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit

class QRCodeScannerViewController: UIViewController {
    
    // MARK: - UI Components
    private let qrCodeCameraViewController = QRCodeCameraViewController()
    private let stackView = UIStackView()
    private let iconImageView = UIImageView()
    private let scannedBarcodeLabel = UILabel()
    private let scannedBarcodeValueLabel = UILabel()
    private let scanAgainButton = FTButton(backgroundColor: .blue, title: "Scan Again?")
        
    // MARK: - ViewModel
    var viewModel: QRCodeScannerViewModel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCameraPreview()
        setupScannedBarcodeStack()
        setupScannedBarcodeValueLabel()
        setupScanAgainButton()
    }
        
    // MARK: - View Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "QR Code Scanner"
    }
    
    private func setupCameraPreview() {
        addChild(qrCodeCameraViewController)
        qrCodeCameraViewController.delegate = self
        qrCodeCameraViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrCodeCameraViewController.view)

        NSLayoutConstraint.activate([
            qrCodeCameraViewController.view.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -70),
            qrCodeCameraViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            qrCodeCameraViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            qrCodeCameraViewController.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])

        qrCodeCameraViewController.didMove(toParent: self)

    }
    
    private func setupScannedBarcodeStack() {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8

        iconImageView.image = UIImage(systemName: "qrcode.viewfinder")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .label

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])

        scannedBarcodeLabel.text = "Scanned QR Code:"
        scannedBarcodeLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        scannedBarcodeLabel.textColor = .label

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(scannedBarcodeLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: qrCodeCameraViewController.view.bottomAnchor, constant: 12),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupScannedBarcodeValueLabel() {
        view.addSubview(scannedBarcodeValueLabel)
        scannedBarcodeValueLabel.text = "Not Yet Scanned"
        scannedBarcodeValueLabel.font = UIFont.boldSystemFont(ofSize: 36)
        scannedBarcodeValueLabel.textColor = .red
        scannedBarcodeValueLabel.textAlignment = .center
        scannedBarcodeValueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scannedBarcodeValueLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            scannedBarcodeValueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scannedBarcodeValueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupScanAgainButton() {
        view.addSubview(scanAgainButton)
        scanAgainButton.isHidden = true
        scanAgainButton.addTarget(self, action: #selector(scanAgainButtonTapped), for: .touchUpInside)
        scanAgainButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scanAgainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scanAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scanAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            scanAgainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func scanAgainButtonTapped() {
        resetScanningState()
    }
    
    private func resetScanningState() {
        DispatchQueue.main.async { [weak self] in
            self?.scannedBarcodeValueLabel.text = "Not Yet Scanned"
            self?.scannedBarcodeValueLabel.textColor = .red
            self?.scanAgainButton.isHidden = true
            self?.qrCodeCameraViewController.restartScanning()
        }
    }

    deinit {
        print("\(self) deallocated")
    }

}

extension QRCodeScannerViewController: QRCodeCameraViewControllerDelegate {
    func didCaptureQRCode(_ barcode: String) {
        DispatchQueue.main.async { [weak self] in
            self?.scannedBarcodeValueLabel.text = barcode
            self?.scannedBarcodeValueLabel.textColor = .green
            self?.scanAgainButton.isHidden = false
        }
    }

    func didSurface(error: CameraError) {
        
        switch error {
        case .invalidDeviceInput:
            self.presentAlert(alertItem: AlertContext.invalidDeviceInput)
        case .invalidScannedValue:
            self.presentAlert(alertItem: AlertContext.invalidScannedType)
        case .cameraAccessDenied:
            self.presentAlert(alertItem: AlertContext.cameraAccessDenied)
        }
    }

}


@available(iOS 17, *)
#Preview {
    QRCodeScannerViewController()
}
