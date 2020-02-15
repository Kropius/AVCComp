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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBarTransparent()
        
        view.setBackground()
        startTestButton.titleLabel?.textColor = .black
        viewMapButton.titleLabel?.textColor = .black
        callButton.titleLabel?.textColor = .black
        
        designButton(button: startTestButton)
        designButton(button: viewMapButton)
        designButton(button: callButton)
    }
    
    func designButton(button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0
        button.layer.borderWidth = 2.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }
    
    func makeNavigationBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func startTest(sender: Any) {
//        if let photoVC = storyboard?.instantiateViewController(identifier: "PhotoViewController") as? PhotoViewController {
//            navigationController?.pushViewController(photoVC, animated: true)
//        }
        if let photoVC = storyboard?.instantiateViewController(identifier: "ArmWeaknessViewController") as? ArmWeaknessViewController {
                   navigationController?.pushViewController(photoVC, animated: true)
               }
    }
    
    @IBAction func goToMap(_ sender: Any) {
        if let mapVC = storyboard?.instantiateViewController(identifier: "MapViewController") as? MapViewController {
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    @IBAction func callEmergency(_ sender: Any) {
        if let url = URL(string: "tel://0727798371"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension UIView {
    func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        let colorTop = UIColor(red: 11/255, green: 83/255, blue: 137/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 130/255, green: 208/255, blue: 242/255, alpha: 1.0).cgColor
        gradientLayer.locations = [0.0, 1.0, 1.0]
        gradientLayer.colors = [colorTop,colorBottom,UIColor.white.cgColor]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
