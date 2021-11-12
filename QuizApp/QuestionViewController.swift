//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 12/11/21.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource {
    private var question: String = ""
    private var options: [String] = []
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    convenience init(question: String, options: [String]) {
        self.init()
        self.question = question
        self.options = options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
}
