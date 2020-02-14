//
//  PacientData.swift
//  Planetarium
//
//  Created by Irina Cercel on 11/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import Foundation

struct PacientData {
    var photoDetails: Data!
    var recordingDetails: Data!
    var textDetails: Data!

    func request(url: URL, method: String, body: Data? = nil, boundary: String? = nil, pacientCompletionHandler: @escaping (Data?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = body
            print(String(data: request.httpBody!, encoding: String.Encoding.utf8))
        }
        if let boundary = boundary {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        else {
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                pacientCompletionHandler(nil,error)
            } else {
                if let data = data, let response = response {
                    pacientCompletionHandler(data,nil)
        //            let result = String(data: data,encoding: String.Encoding.utf8)
                }
            }
        }
        task.resume()
    }

    func createBody(bodyParams: [String: Int]? = nil, param: String, data: Data, boundary: String, filename: String, mimetype: String) -> Data {
        let body = NSMutableData()
        
        if let bodyParams = bodyParams {
            for (key, value) in bodyParams {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        return body as Data
    }
    
    func createBodywithParam(bodyParams: [String: Any], boundary: String) -> Data {
        let body = NSMutableData()
        for (key, value) in bodyParams {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body as Data
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
