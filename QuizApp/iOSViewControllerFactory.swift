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
    
    init(options: [Question<String>: [String]]) {
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallack: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return QuestionViewController(question: value, options: options[question]!, selection: answerCallack)
        default:
            return UIViewController()
        }
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
}
