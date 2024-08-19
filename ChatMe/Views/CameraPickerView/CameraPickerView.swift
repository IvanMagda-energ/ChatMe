//
//  CameraPickerView.swift
//  ChatMe
//
//  Created by Ivan Magda on 09.08.2024.
//

import UIKit
import SwiftUI
import os

struct CameraPickerView: UIViewControllerRepresentable {
    private let logger = Logger(
        subsystem: String(describing: Bundle.main.bundleIdentifier),
        category: String(describing: CameraPickerView.self))
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @Binding var photo: UIImage?
    
    private let sourceType: UIImagePickerController.SourceType = .camera
    private let cameraDevice: UIImagePickerController.CameraDevice = .rear
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPickerView>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        imagePicker.cameraCaptureMode = .photo
        imagePicker.videoQuality = .typeHigh
        imagePicker.cameraDevice = cameraDevice
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPickerView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraPickerView
        init(_ parent: CameraPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.parent.photo = uiImage
                
                parent.logger.info("Photo from camera picker successfully captured")
                
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
