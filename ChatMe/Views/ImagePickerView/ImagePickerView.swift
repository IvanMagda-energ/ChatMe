//
//  ImagePickerView.swift
//  ChatMe
//
//  Created by Ivan Magda on 09.08.2024.
//

import SwiftUI
import PhotosUI

/// This view displays a button that, when clicked, displays a menu with the option to open the photo gallery and select a photo, or open the camera and take a photo.
/// - Parameter label: label for button `View`
/// - Returns: completion with imageData as `Data`
struct ImagePickerView<Label: View>: View {
    @Binding var image: UIImage?
    @ViewBuilder var label: Label
    
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var showImageSelectionMenu = false
    @State private var isShowCameraPicker = false
    @State private var isShowGalleryPicker = false
    
    var body: some View {
        Group {
            Button {
                showImageSelectionMenu.toggle()
            } label: {
                label
            }
            .buttonStyle(.plain)
            .confirmationDialog(
                LocalizedStrings.pickerMenuTitle,
                isPresented: $showImageSelectionMenu,
                titleVisibility: .visible
            ) {
                // MARK: - Camera picker
                Button {
                    isShowCameraPicker.toggle()
                } label: {
                    Text(LocalizedStrings.cameraButton)
                }
                // MARK: - Gallery picker
                Button {
                    isShowGalleryPicker.toggle()
                } label: {
                    Text(LocalizedStrings.galleryButton)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowCameraPicker) {
            CameraPickerView(photo: $image)
                .ignoresSafeArea()
        }
        .photosPicker(
            isPresented: $isShowGalleryPicker,
            selection: $selectedPickerItem,
            matching: .images
        )
        .onChange(of: selectedPickerItem) {
            Task {
                guard let imageData = try await selectedPickerItem?.loadTransferable(type: Data.self) else {
                    return
                }
                
                guard let uiImage = UIImage(data: imageData) else {
                    return
                }
                
                self.image = uiImage
            }
        }
    }
}

extension ImagePickerView {
    private enum LocalizedStrings {
        static var cameraButton: String {
            NSLocalizedString("camera.picker.button", comment: "Title for camera picker button")
        }
        static var galleryButton: String {
            NSLocalizedString("gallery.picker.button", comment: "Title for gallery picker button")
        }
        static var pickerMenuTitle: String {
            NSLocalizedString("change.avatar.menu.title", comment: "The title of the window for changing the avatar")
        }
    }
}

