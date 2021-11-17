//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 15/11/21.
//

import XCTest
import QuizGame
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
        
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: {_ in })

        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToResult_presentResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        let result = Result(answers: [
            Question.singleAnswer("Q1"): "A1"]
, scores: 10)
        let secondResult = Result(answers: [
            Question.singleAnswer("Q2"): "A2"], scores: 20)

        factory.stub(result: result, viewController: viewController)
        factory.stub(result: secondResult, viewController: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuetion_presentRightViewControllerWithRightAnswerCallback() {
        factory.stub(question: Question.singleAnswer("Q1"), with: UIViewController())
        
        var callbackFired = false
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: {_ in callbackFired = true})
        factory.answerCallbacks[Question.singleAnswer("Q1")]?("A1")
        
        XCTAssertTrue(callbackFired)
    }
    
    class NonAnimatedNavigationCntroller: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestion = [Question<String>: UIViewController]()
        var answerCallbacks = [Question<String>: ((String) -> Void)]()
        var stubbedResults = [Result<Question<String>, String>: UIViewController]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestion[question] = viewController
        }
        
        func stub(result: Result<Question<String>, String>, viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallack: @escaping (String) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallack
            return stubbedQuestion[question] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, String>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
    }
}

extension Result: Hashable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.scores == rhs.scores
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(scores)
    }
}
