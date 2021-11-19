//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 17/11/21.
//
import UIKit
import QuizGame

class iOSViewControllerFactory: ViewControllerFactory {
    private let options: [Question<String>: [String]]
    private let correctAnswers: [Question<String>: Set<String>]
    private let questions: [Question<String>]
    
    init(questions: [Question<String>],
         options: [Question<String>: [String]],
         correctAnswers: [Question<String>: Set<String>]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping((Set<String>) -> Void)) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
        case .multipleAnswer(let value):
            let controller = questionViewController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
            return controller
        }
    }
    
    private func questionViewController(for question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool, answerCallback: @escaping((Set<String>) -> Void)) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller =  QuestionViewController(question: value, options: options, isMultipleSelection: allowsMultipleSelection, selection: { answerCallback(Set($0))})
        controller.title = presenter.title
        return controller
    }
    
    func resultViewController(for result: Result<Question<String>, Set<String>>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, correctAnswers: correctAnswers, options: options, orderedQuestions: questions)
        return ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
    }
}
