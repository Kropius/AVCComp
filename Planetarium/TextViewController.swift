//
//  TextViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 12/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    var pacientResults: PacientData!
    var text_id: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.getText()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setBackground()
        sendButton.isHidden = true
        sendButton.isEnabled = false
        textField.delegate = self
    }
    
    func getText() {
        if let url = URL(string: "http://127.0.0.1:5001/get_text") {
            pacientResults.request(url: url, method: "GET", pacientCompletionHandler: {
                data, error in
                if let error = error {
                    print("Error:", error)
                    self.textLabel.text = "Couldn't get the text!"
                }
                else {
                    do {
//                        print(String(data: data!, encoding: String.Encoding.utf8)!)
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
                        self.textLabel.text = "Couldn't get the text!"
                    }
                }
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sendButton.isEnabled = true
        sendButton.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        sendButton.isEnabled = true
        sendButton.isHidden = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getPostString(params: [String: Any]) -> String {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    
    @IBAction func sendText(_ sender: Any) {
        if let textWritten = textField.text {
            if let newurl = URL(string: "http://127.0.0.1:5001/send_texting_test") {
                let body: [String: String] = [
                    "input_text": String(textWritten),
                    "id_text": String(text_id!)
                ]
                let dataBody = getPostString(params: body).data(using: String.Encoding.utf8)
                pacientResults.request(url: newurl, method: "POST", body: dataBody, pacientCompletionHandler: { data, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            self.pacientResults.textDetails = data
//                            print(String(data: data, encoding: String.Encoding.utf8))
                            if let resultVC = self.storyboard?.instantiateViewController(identifier: "ResultViewController") as? ResultViewController {
                                resultVC.pacientResult = self.pacientResults
                                self.navigationController?.pushViewController(resultVC, animated: true)
                            }
                        }
                    }
                })
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
