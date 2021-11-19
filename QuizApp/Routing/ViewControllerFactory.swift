//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 17/11/21.
//

import UIKit
@testable import QuizGame

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>, Set<String>>) -> UIViewController
}
