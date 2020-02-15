//
//  RecordViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 08/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, UINavigationControllerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet var recordVoiceButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var pacientResults: PacientData!
    var text_id: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        recordVoiceButton.isHidden = true
        recordVoiceButton.isEnabled = false
        stopRecordingButton.setTitle("Stop recording", for: .normal)
        stopRecordingButton.isEnabled = false
        stopRecordingButton.isHidden = true
        warningLabel.isHidden = true
        warningLabel.textColor = .red

        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                    if allowed {
                        print("Allowed")
                        self.recordVoiceButton.isHidden = false
                        self.recordVoiceButton.isEnabled = true
                        self.getText()
                    } else {
                        print("Not allowed")
                    }
                }
            }
        } catch {
            print("Can't record!")
        }
    }
    
    func getText() {
        if let url = URL(string: "http://127.0.0.1:5001/get_text") {
            pacientResults.request(url: url, method: "GET", pacientCompletionHandler: {
                data, error in
                if let error = error {
                    print("Error:", error)
                    self.warningLabel.isHidden = false
                    self.warningLabel.text = "Couldn't get the text!"
                }
                else {
                    do {
                        print(String(data: data!, encoding: String.Encoding.utf8)!)
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let id = json["id"], let text = json["text"] {
                                DispatchQueue.main.async {
                                    self.text_id = id as? Int
                                    self.textLabel.text = text as? String
                                }
                            }
                        }
                    } catch let err as NSError{
                        print(err)
                        self.warningLabel.isHidden = false
                        self.warningLabel.text = "Couldn't get the text!"
                    }
                }
            })
        }
    }
    
    @IBAction func record(_ sender: Any) {
        self.stopRecordingButton.isHidden = false
        self.stopRecordingButton.isEnabled = true
        warningLabel.isHidden = true
        
        let audioFileName = getDocumentsDirectory().appendingPathComponent("recording.wav") as URL
        
        let settings: [String : Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 8,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        print(audioFileName.absoluteString)
        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.prepareToRecord()
            self.audioRecorder.record()
        } catch {
            print("nu merge recordingul")
          self.finishRecording(succes: false)
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        finishRecording(succes: true)
    }
    
    func finishRecording(succes: Bool) {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
        
        warningLabel.isHidden = false
        if succes {
            self.recordVoiceButton.setTitle("Start Recording", for: .normal)
            
            if self.stopRecordingButton.titleLabel?.text == "Send recording" {
                print("trimit")
                if let recording = NSData(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.wav")) {
                    guard let url = URL(string: "http://127.0.0.1:5001/parse_voice") else {
                               print("Eroare la request inregistrare!")
                               return
                           }
                    
                    let bodyParams = ["id_text": text_id]
                    let boundary = pacientResults.generateBoundaryString()
                    let body = pacientResults.createBody(bodyParams: bodyParams as? [String : Int], param: "recording", data: recording as Data, boundary: boundary, filename: "recording.wav", mimetype: "audio/x-wav")
                    
                    pacientResults.request(url: url, method: "POST", body: body, boundary: boundary, pacientCompletionHandler: { data,error in
                            if let error = error {
                                print(error)
                                return
                            } else {
                                DispatchQueue.main.async {
                                    print(String(data: data!,encoding: String.Encoding.utf8)!)
                                    self.pacientResults.recordingDetails = data
                                    self.stopRecordingButton.setTitle("Stop recording", for: .normal)
                                    self.stopRecordingButton.isEnabled = false
                                    self.stopRecordingButton.isHidden = true
                                    self.warningLabel.text = "Recording sent with succes!"
                                    if let textVC = self.storyboard?.instantiateViewController(identifier: "TextViewController") as? TextViewController {
                                        textVC.pacientResults = self.pacientResults
                                        self.navigationController?.pushViewController(textVC, animated: true)
                                    }
                                }
                            }
                    })
                }
                    
            } else {
                print("opresc")
                self.stopRecordingButton.setTitle("Send recording", for: .normal)
                self.warningLabel.text = "Recording saved!"
            }
        } else {
            print("eroare")
            warningLabel.text = "There was a problem with the recording!"
            recordVoiceButton.titleLabel?.text = "Record again"
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(succes: false)
        }
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
