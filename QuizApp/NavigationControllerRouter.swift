//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 16/11/21.
//

import QuizGame
import UIKit

enum Question<T: Hashable> {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    var hashValue: Int {
        switch self {
        case .singleAnswer(let a):
            return a.hashValue
        case .multipleAnswer(let b):
            return b.hashValue
        }
    }
}

protocol ViewControllerFactory {
    func questionViewController(for question: String, answerCallack: @escaping (String) -> Void) -> UIViewController
}

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        let viewController = factory.questionViewController(for: question, answerCallack: answerCallback)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeTo(result: Result<String, String>) {
        
    }
}
