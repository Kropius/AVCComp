//
//  QuestionTestViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 15/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit

class QuestionTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionlLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
//    var questions = [
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let answerCell = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        tableView.register(answerCell, forCellReuseIdentifier: "AnswerTableViewCell")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           return UITableViewCell()
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
