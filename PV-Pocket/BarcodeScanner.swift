//
//  CarBode.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 12/6/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import AVFoundation

//Calling this struct creates an instance of a barcode scanner to be used for any purpose

/* EXAMPLE USAGE
 import SwiftUI
 import CarBode

 struct ContentView: View {
     var body: some View {
         VStack{
         CarBode(supportBarcode: [.qr, .code128]) //Set type of barcode you want to scan
                     .interval(delay: 5.0) //Event will trigger every 5 seconds
                        .found{
                             // Your code runs here when a barcode is found
                             print($0)
                       }
         }
     }
 }
 */

// MARK: Barcode Scanner
public struct BarcodeScanner: UIViewRepresentable {

    public var supportBarcode: [AVMetadataObject.ObjectType]

    public typealias UIViewType = CameraPreview

    let delegate = Delegate()
    let session = AVCaptureSession()
    
    public init(supportBarcode: [AVMetadataObject.ObjectType]){
        self.supportBarcode = supportBarcode
    }
    
    public func interval(delay:Double)-> BarcodeScanner {
        delegate.scanInterval = delay
        return self
    }

    public func found(r: @escaping (String) -> Void) -> BarcodeScanner {
        delegate.onResult = r
        return self
    }

    func setupCamera(_ uiView: CameraPreview) {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if let input = try? AVCaptureDeviceInput(device: backCamera) {

                let metadataOutput = AVCaptureMetadataOutput()

                session.sessionPreset = .photo

                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    metadataOutput.metadataObjectTypes = supportBarcode
                    metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                }
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)

                uiView.backgroundColor = UIColor.gray
                previewLayer.videoGravity = .resizeAspectFill
                uiView.layer.addSublayer(previewLayer)
                uiView.previewLayer = previewLayer

                session.startRunning()
            }
        }
    }

    public func makeUIView(context: UIViewRepresentableContext<BarcodeScanner>) -> BarcodeScanner.UIViewType {
        return CameraPreview(frame: .zero)
    }

    public func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<BarcodeScanner>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        if cameraAuthorizationStatus == .authorized {
            setupCamera(uiView)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera(uiView)
                    }
                }
            }
        }
    }

}

public class CameraPreview: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer?
    override public func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
}

class Delegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var scanInterval:Double = 3.0
    var lastTime = Date(timeIntervalSince1970: 0)

    var onResult: (String) -> Void = { _ in }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            let now = Date()
            if now.timeIntervalSince(lastTime) >= scanInterval {
                lastTime = now
                self.onResult(stringValue)
            }
        }

    }
}

struct Scanner: View {
   
    @State var classShow = false
    @State var code = "nil"
    @State var scanned = false
    
    var body: some View {
        VStack {
            BarcodeScanner(supportBarcode: [.code128, .code93, .code39, .qr])
        .interval(delay: 5.0)
            .found{
            self.code = $0
            self.scanned = true
         }
        }
        .alert(isPresented: $scanned) {
            Alert(title: Text("Is this your school ID?"), message: Text(code), dismissButton: .default(Text("Yes it is!")))
        }
    }
}
