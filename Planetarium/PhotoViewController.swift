//
//  PhotoViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 08/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit
import Photos
import Foundation

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var selectImageFromGalleryButton: UIButton!
    @IBOutlet var sendPhotoButton: UIButton!
    @IBOutlet var selectedPhoto: UIImageView!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        sendPhotoButton.isEnabled = false
        sendPhotoButton.isHidden = true
    }
    
    @IBAction func takePhoto(sender: Any) {
        imagePicker.sourceType = .camera
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            present(imagePicker,animated: true,completion: nil)
        case .notDetermined: AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                        self.present(self.imagePicker,animated: true,completion: nil)
                }
            }
        }
        case .restricted:
            print("Acces restricted!")
        case .denied:
            print("Acces denined!")
        @unknown default:
            return
        }
    }
    
    @IBAction func selectImageFromGallery(sender: Any) {
        imagePicker.sourceType = .photoLibrary
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined: PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in
            if PHAuthorizationStatus == .authorized {
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        case .authorized:
            present(self.imagePicker, animated: true, completion: nil)
        case .denied, .restricted:
            print("Acces denied/restricted!")
        @unknown default:
            return
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] {
            selectedPhoto.image = img as? UIImage
            sendPhotoButton.isHidden = false
            sendPhotoButton.isEnabled = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPhoto(_ sender: Any) {
        
        guard let url = URL(string: "http://127.0.0.1:5001/check_symmetry_send_img") else {
            print("Eroare la request image!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = ["image": selectedPhoto.image!.jpegData(compressionQuality: 0.9)!]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = createBody(param: "image", imageData: selectedPhoto.image!.jpegData(compressionQuality: 0.9)!, boundary: boundary)
        
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: ["image": selectedPhoto.image!.pngData()], options: [])
//        } catch {
//            print("Eroare la json to data(image)!")
//            return
//        }
//
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data, let response = response {
                print("Response: \(response)")
                print("Data:",data)
                let result = String(data: data,encoding: String.Encoding.utf8)
                print(result)
            }
        }
        task.resume()
        
        if let recordVC = storyboard?.instantiateViewController(identifier: "RecordViewController") as? RecordViewController {
            navigationController?.pushViewController(recordVC, animated: true)
        }
    }
    
    func createBody(param: String, imageData: Data, boundary: String) -> Data {
        let body = NSMutableData()

        let filename = "face_photo.jpg"
        let mimetype = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
