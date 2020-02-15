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
    @IBOutlet var firstPhoto: UIImageView!
    @IBOutlet var secondPhoto: UIImageView!
    
    var pacientResults: PacientData!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        sendPhotoButton.isEnabled = false
        sendPhotoButton.isHidden = true
        pacientResults = PacientData()
        
        takePhotoButton.setTitle("Take a normal photo", for: .normal)
        selectImageFromGalleryButton.setTitle("Select a normal photo from gallery", for: .normal)
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
            if firstPhoto.image == nil {
                firstPhoto.image = img as? UIImage
                takePhotoButton.setTitle("Take a photo smiling", for: .normal)
                selectImageFromGalleryButton.setTitle("Select a smiling photo from gallery", for: .normal)
            } else {
                secondPhoto.image = img as? UIImage
                sendPhotoButton.isHidden = false
                sendPhotoButton.isEnabled = true
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func sendPhoto(body: Data, boundary: String, url: String) {
        guard let url = URL(string: url) else {
                   print("Eroare la request image!")
                   return
               }
        
        pacientResults.request(url: url, method: "POST", body: body, boundary: boundary, pacientCompletionHandler: {data, error in
            if let error = error{
                print(error)
                return
            } else if data != nil {
//                print(String(data: data!, encoding: String.Encoding.utf8))
                DispatchQueue.main.async {
                    if self.pacientResults.firstPhotoDetails == nil {
                        self.pacientResults.firstPhotoDetails = data
                    } else {
                        self.pacientResults.secondPhotoDetails = data
                        if let recordVC = self.storyboard?.instantiateViewController(identifier: "RecordViewController") as? RecordViewController {
                                   recordVC.pacientResults = self.pacientResults
                                   self.navigationController?.pushViewController(recordVC, animated: true)
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func sendPhotosButtonPressed(_ sender: Any) {
        let boundary = pacientResults.generateBoundaryString()
        sendPhoto(body: pacientResults.createBody(param: "image", data: firstPhoto.image!.jpegData(compressionQuality: 0.9)!, boundary: boundary, filename: "normal_face_photo.jpg", mimetype: "image/jpg"),boundary: boundary, url: "http://127.0.0.1:5001/check_symmetry_send_img")
        sendPhoto(body: pacientResults.createBody(param: "image", data: secondPhoto.image!.jpegData(compressionQuality: 0.9)!, boundary: boundary, filename: "smiley_face_photo.jpg", mimetype: "image/jpg"),boundary: boundary, url: "http://127.0.0.1:5001//get_smiley_corners")
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
