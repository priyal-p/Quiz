//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 14/11/21.
//

import UIKit

class ResultsViewController: UIViewController {
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        return answer.wrongAnswer == nil ? correctAnswerCell(answer: answer)
        : wrongAnswerCell(answer: answer)
    }
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return answers[indexPath.row].wrongAnswer == nil ? 70 : 100
    }
}
private extension ResultsViewController {
    func correctAnswerCell(answer: PresentableAnswer) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(for: CorrectAnswerCell.self) {
            cell.questionLabel.text = answer.question
            cell.answerLabel.text = answer.answer
            return cell
        }
        return UITableViewCell()
    }
    
    func wrongAnswerCell(answer: PresentableAnswer) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(for: WrongAnswerCell.self) {
            cell.questionLabel.text = answer.question
            cell.correctAnswerLabel.text = answer.answer
            cell.wrongAnswerLabel.text = answer.wrongAnswer
            return cell
        }
        return UITableViewCell()
    }
}
