//
//  ImagePicker.swift
//  GoodEats
//
//  Created by Minh Pham on 12/6/23.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // use those files to pick images
    func makeUIViewController(context: Context) -> UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // perform picked to select image from the user library
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let imageProvider = results.first?.itemProvider, imageProvider.canLoadObject(ofClass: UIImage.self) {
                imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image
                            self.parent.isPresented = false
                        }
                    }
                }
            }
            // return the statement to show that there exist a picture in the system
            else {
                parent.isPresented = false
            }
        }
    }
}
