//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 16/11/21.
//

import QuizGame
import UIKit

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallack: @escaping (String) -> Void) -> UIViewController
}

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping (String) -> Void) {
        let viewController = factory.questionViewController(for: question, answerCallack: answerCallback)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeTo(result: Result<Question<String>, String>) {
        
    }
}
