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
    
    var pacientResults: PacientData!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        sendPhotoButton.isEnabled = false
        sendPhotoButton.isHidden = true
        pacientResults = PacientData()
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
        let boundary = pacientResults.generateBoundaryString()
        let body = pacientResults.createBody(param: "image", data: selectedPhoto.image!.jpegData(compressionQuality: 0.9)!, boundary: boundary, filename: "face_photo.jpg", mimetype: "image/jpg")
        
        pacientResults.request(url: url, method: "POST", body: body, boundary: boundary, pacientCompletionHandler: {data, error in
            if let error = error{
                print(error)
                return
            } else {
                DispatchQueue.main.async {
                    self.pacientResults.photoDetails = data
                    
                    if let recordVC = self.storyboard?.instantiateViewController(identifier: "RecordViewController") as? RecordViewController {
                        recordVC.pacientResults = self.pacientResults
                        self.navigationController?.pushViewController(recordVC, animated: true)
                    }
                }
                
            }
        })
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
