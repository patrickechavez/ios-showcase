//
//  QRCodeCameraViewController.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/16/24.
//

import UIKit
import AVFoundation

protocol QRCodeCameraViewControllerDelegate: AnyObject {
    func didCaptureQRCode(_ qrCode: String)
    func didSurface(error: CameraError)
}

class QRCodeCameraViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: QRCodeCameraViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
         requestCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    // MARK: - Camera Permission
    private func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.handleCameraPermissionDenied()
                    }
                }
            }
        case .authorized:
            setupCamera()
        case .restricted, .denied:
            handleCameraPermissionDenied()
        @unknown default:
            print("Unknown camera authorization status.")
        }
    }
    
    private func handleCameraPermissionDenied() {
        delegate?.didSurface(error: .cameraAccessDenied)
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            delegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                delegate?.didSurface(error: .invalidDeviceInput)
                return
            }
        } catch {
            delegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.qr]
        } else {
            delegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        configurePreviewLayer()
        startCaptureSession()
    }
    
    private func configurePreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    // MARK: - Public Methods
    func restartScanning() {
        guard !captureSession.isRunning else { return }
        startCaptureSession()
        reassignMetadataDelegate()
    }
    
    private func reassignMetadataDelegate() {
        let metaDataOutput = captureSession.outputs.compactMap { $0 as? AVCaptureMetadataOutput }.first
        metaDataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }

}

extension QRCodeCameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let qrCode = object.stringValue else {
            delegate?.didSurface(error: .invalidScannedValue)
            return
        }
    
        // Notify delegate about the captured QRCode
        delegate?.didCaptureQRCode(qrCode)
        stopCaptureSession(output)
        
    }
    
    // Prevent further delegate calls
    private func stopCaptureSession(_ output: AVCaptureMetadataOutput) {
        captureSession.stopRunning()
        output.setMetadataObjectsDelegate(nil, queue: nil) // Prevent duplicate calls
    }
    
}

