//
//  ContentView.swift
//  Planetarium
//
//  Created by Irina Cercel on 03/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var startTestButton: UIButton!
    @IBOutlet var viewMapButton: UIButton!
    @IBOutlet var callButton: UIButton!

    
    @IBAction func startTest(sender: Any) {
        if let photoVC = storyboard?.instantiateViewController(identifier: "PhotoViewController") as? PhotoViewController {
            navigationController?.pushViewController(photoVC, animated: true)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
