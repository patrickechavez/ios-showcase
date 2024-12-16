//
//  BarcodeCameraView.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/15/24.
//

import UIKit
import AVFoundation

protocol BarcodeCameraViewDelegate: AnyObject {
    func didCaptureBarcode(_ barcode: String)
    func didSurface(error: CameraError)
}

class BarcodeCameraView: UIView {
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: BarcodeCameraViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        requestCameraPermission()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
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
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
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
            layer.addSublayer(previewLayer)
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
    
    func stopCamera() {
        captureSession.stopRunning()
        previewLayer?.removeFromSuperlayer()
    }
    
    private func reassignMetadataDelegate() {
        let metaDataOutput = captureSession.outputs.compactMap { $0 as? AVCaptureMetadataOutput }.first
        metaDataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
}

extension BarcodeCameraView: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let barcode = object.stringValue else {
            delegate?.didSurface(error: .invalidScannedValue)
            return
        }

        // Notify delegate about the captured barcode
        delegate?.didCaptureBarcode(barcode)
        stopCaptureSession(output)
    }
    
    // Prevent further delegate calls
    private func stopCaptureSession(_ output: AVCaptureMetadataOutput) {
        captureSession.stopRunning()
        output.setMetadataObjectsDelegate(nil, queue: nil)
    }
}

@available(iOS 17, *)
#Preview {
    BarcodeCameraView()
}
