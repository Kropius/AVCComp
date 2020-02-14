//
//  ResultViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 14/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    
    var pacientResult: PacientData!

    override func viewDidLoad() {
        super.viewDidLoad()
        getResult()
        // Do any additional setup after loading the view.
    }
    
    func getResult() {
        var body = NSMutableData()
//        print(String(data: pacientResult.secondPhotoDetails, encoding: String.Encoding.utf8))
        body.append(pacientResult.firstPhotoDetails)
        body.append(pacientResult.secondPhotoDetails)
        body.append(pacientResult.recordingDetails)
        body.append(pacientResult.textDetails)
        print(String(data: body as Data, encoding: String.Encoding.utf8))
        if let url = URL(string: "http://127.0.0.1:5001/send_final_result") {
            pacientResult.request(url: url, method: "POST", body: body as Data) { (data, error) in
                if let error = error {
                    print(error)
                    self.resultLabel.text = error as? String
                }
                if data != nil {
                    DispatchQueue.main.async {
                        self.resultLabel.text = String(data: data!, encoding: String.Encoding.utf8)
//                        print(String(data: data!, encoding: String.Encoding.utf8))
                    }
                   
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
