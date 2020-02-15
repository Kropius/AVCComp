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

    var countdown = 3
    var count = 10
    let motionManager = CMMotionManager()
    var timer: Timer!
    var coordinates: [(Double,Double,Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownLabel.isHidden = true
        countdownLabel.text = String(countdown)
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
                    coordinates.append((x,y,z))
                    print(type(of:x),y,z)
                }
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
