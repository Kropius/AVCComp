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
    @IBOutlet var sendRecordButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        recordVoiceButton.isHidden = true
        recordVoiceButton.isEnabled = false
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                    if allowed {
                        print("Allowed")
                        self.recordVoiceButton.isHidden = false
                        self.recordVoiceButton.isEnabled = true
                        
                    } else {
                        print("Not allowed")
                    }
                }
            }
        } catch {
            print("Can't record!")
        }
        
        sendRecordButton.isHidden = true
        sendRecordButton.isEnabled = false
    }
    
    @IBAction func record(_ sender: Any) {
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
    //      self.finishRecording(succes: false)
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("S-a salvat cu succes")
        finishRecording(succes: true)
    }
    
    func finishRecording(succes: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if succes {
            recordVoiceButton.titleLabel?.text = "Record"
            sendRecordButton.isHidden = false
            sendRecordButton.isEnabled = true
            
        }
        else {
            recordVoiceButton.titleLabel?.text = "Record again"
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(succes: false)
        }
        else{
//            let recordedAudio = RecordedAudio()
//            recordedAudio.filePathUrl = recorder.url
//            recordedAudio.title = recorder.url.lastPathComponent
//            print(recordedAudio.title)

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
