//
//  ArmWeaknessViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 15/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit
import CoreMotion

class ArmWeaknessViewController: UIViewController {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var sendResultsButton: UIButton!

    var countdown = 3
    var count = 10
    let motionManager = CMMotionManager()
    var timer: Timer!
    var coordinates: [[Double]] = []
        
    var mockCoordinates = [[0.22497636645745997, 0.13452730940682117, 0.022041963251696692], [0.22680693413820507, 0.06474429458439875, -0.04879315292905099], [-0.015189990640550047, -0.020964872225630864, -0.16091586758328086], [-0.43130026850881764, -0.07278487417225012, -0.19203855639819153], [-0.7948573569725206, 0.013487304098859215, -0.17295894714255933], [-0.9639135037090861, 0.3193130098868618, -0.022219781783640112], [-1.0366717122705482, 0.30050319215643906, -0.06997842834349165], [-1.0569595213950629, 0.23335919426555288, -0.11872151621099213], [-1.0591346093162857, 0.21899743808574626, -0.13567631352497103]]
    var pacientResults: PacientData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownLabel.isHidden = true
        countdownLabel.text = String(countdown)
        view.setBackground()
//        sendResultsButton.isHidden = true
//        sendResultsButton.isEnabled = false
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        countdownLabel.isHidden = false
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        if(countdown-1 > 0) {
            countdownLabel.text = String(countdown-1)
            countdown -= 1
        } else if (countdown-1 == 0) {
            countdown -= 1
            countdownLabel.isHidden = true
            
            motionManager.startDeviceMotionUpdates()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateMotion), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateMotion() {
        if motionManager.deviceMotion != nil {
            if(count - 1 > 0) {
                print(count)
                countdownLabel.text = String(count - 1)
                count -= 1
                if let data = self.motionManager.deviceMotion {
                // Get the attitude relative to the magnetic north reference frame.
                    let x = data.attitude.pitch
                    let y = data.attitude.roll
                    let z = data.attitude.yaw
                    coordinates.append([x,y,z])
                    print(coordinates)
                }
            }
            else {
                sendResultsButton.isHidden = false
                sendResultsButton.isEnabled = true
            }
        }
    }
    func getPostString(params: [String: Any]) -> String {
           var data = [String]()
           for(key, value) in params
           {
               data.append(key + "=\(value)")
           }
           return data.map { String($0) }.joined(separator: "&")
       }
    
    @IBAction func sendCoordinates() {
        let body = ["coordinates": mockCoordinates]
        if let url = URL(string: "http://127.0.0.1:5001//get_movement_disorder") {
            do {
                let json = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                pacientResults.request(url: url, method: "POST", body: json, header: true) { (data, error) in
                    if error != nil {
                        print(error as Any)
                    } else if data != nil {
                        DispatchQueue.main.async {
                            self.pacientResults.armWeaknessDetails = data
                            if let textVC = self.storyboard?.instantiateViewController(identifier: "TextViewController") as? TextViewController {
                                textVC.pacientResults = self.pacientResults
                                self.navigationController?.pushViewController(textVC, animated: true)
                            }
                        }
                    }
                }
            } catch let err as NSError {
                print(err)
            }
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
