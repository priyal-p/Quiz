//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 14/11/21.
//

import UIKit

struct PresentableAnswer {
    let question: String
    let answer: String
    let isCorrectAnswer: Bool
}

class CorrectAnswerCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
}

class WrongAnswerCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
}

class ResultsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var summary = ""
    private var answers = [PresentableAnswer]()

    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
        tableView.register(UINib(nibName: "CorrectAnswerCell", bundle: nil), forCellReuseIdentifier: "CorrectAnswerCell")
        tableView.register(UINib(nibName: "WrongAnswerCell", bundle: nil), forCellReuseIdentifier: "WrongAnswerCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.isCorrectAnswer {
            return correctAnswerCell(answer: answer)
        }
        return wrongAnswerCell(answer: answer)
    }
    
    private func correctAnswerCell(answer: PresentableAnswer) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CorrectAnswerCell") as? CorrectAnswerCell {
            cell.questionLabel.text = answer.question
            cell.answerLabel.text = answer.answer
            return cell
        }
        return UITableViewCell()
    }
    
    private func wrongAnswerCell(answer: PresentableAnswer) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WrongAnswerCell") as? WrongAnswerCell {
            cell.questionLabel.text = answer.question
            cell.correctAnswerLabel.text = answer.answer
            return cell
        }
        return UITableViewCell()
    }
}
