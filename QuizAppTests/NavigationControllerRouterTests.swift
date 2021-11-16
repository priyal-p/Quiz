//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 15/11/21.
//

import XCTest
@testable import QuizApp
class NavigationControllerRouterTests: XCTestCase {
    let navigationController = NonAnimatedNavigationCntroller()
    let factory = ViewControllerFactoryStub()
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(navigationController, factory: factory)
    }()
    
    func test_routeToQuetion_presentQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        factory.stub(question: "Q1", with: viewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        sut.routeTo(question: "Q1", answerCallback: {_ in })

        sut.routeTo(question: "Q2", answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuetion_presentRightViewControllerWithRightAnswerCallback() {
        factory.stub(question: "Q1", with: UIViewController())
        
        var callbackFired = false
        sut.routeTo(question: "Q1", answerCallback: {_ in callbackFired = true})
        factory.answerCallbacks["Q1"]?("A1")
        
        XCTAssertTrue(callbackFired)
    }
    
    class NonAnimatedNavigationCntroller: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestion = [String: UIViewController]()
        var answerCallbacks = [String: ((String) -> Void)]()
        
        func stub(question: String, with viewController: UIViewController) {
            stubbedQuestion[question] = viewController
        }
        
        func questionViewController(for question: String, answerCallack: @escaping (String) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallack
            return stubbedQuestion[question] ?? UIViewController()
        }
    }
}
