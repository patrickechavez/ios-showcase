//
//  BarcodeCameraViewController.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/15/24.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func didCaptureBarcode(_ barcode: String)
}

class BarcodeCameraViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: CameraViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureCamera()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    private func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.configureCamera()
                    }
                } else {
                    print("Camera access denied.")
                }
            }
        case .authorized:
            configureCamera()
        case .restricted, .denied:
            print("Camera access denied or restricted.")
        @unknown default:
            print("Unknown camera authorization status.")
        }
    }
    
    private func configureCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Error: videoCaptureDevice")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error: videoInput")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Error: captureSession.canAddInput")
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            print("Error: captureSession.metaDataOutput")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func restartScanning() {
        guard !captureSession.isRunning else { return }
        
        // Restart the session
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
        
        // Reassign the delegate if it was removed earlier
        let metaDataOutput = captureSession.outputs.compactMap { $0 as? AVCaptureMetadataOutput }.first
        metaDataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        print("Scanning restarted.")
    }

}

extension BarcodeCameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            print("Error: AVCaptureMetadataOutputObjectsDelegate")
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            print("Error: AVCaptureMetadataOutputObjectsDelegate")
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            print("Error: AVCaptureMetadataOutputObjectsDelegate")
            return
        }
    
        
        delegate?.didCaptureBarcode(barcode)
        // Stop the capture session
        captureSession.stopRunning()
        
        // Prevent further delegate calls
        output.setMetadataObjectsDelegate(nil, queue: nil)
    }
    
}
