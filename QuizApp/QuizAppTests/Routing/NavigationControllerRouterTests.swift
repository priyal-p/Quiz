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
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let singleAnswerQuestion2 = Question.singleAnswer("Q2")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")

    func test_routeToQuestionOnce_presentQuestionController() {
        sut.routeTo(question: singleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    func test_routeToQuestionTwice_presentQuestionController() {
        sut.routeTo(question: singleAnswerQuestion) { _ in }
        sut.routeTo(question: singleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }

    func test_routeToQuetion_presentQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        factory.stub(question: singleAnswerQuestion, with: viewController)
        factory.stub(question: singleAnswerQuestion2, with: secondViewController)
        
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in })

        sut.routeTo(question: singleAnswerQuestion2, answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToResult_presentResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        let result = Result.make(answers: [
            singleAnswerQuestion: ["A1"]]
, scores: 10)
        let secondResult = Result.make(answers: [
            singleAnswerQuestion2: ["A2"]], scores: 20)

        factory.stub(result: result, viewController: viewController)
        factory.stub(result: secondResult, viewController: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuetion_singleAnswer_answerCallback_progressToNextQuestion() {
        factory.stub(question: singleAnswerQuestion, with: UIViewController())
        
        var callbackFired = false
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in callbackFired = true})
        factory.answerCallbacks[singleAnswerQuestion]?(["A1"])
        
        XCTAssertTrue(callbackFired)
    }
    
    func test_routeToQuetion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        factory.stub(question: multipleAnswerQuestion, with: UIViewController())
        
        var callbackFired = false
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in callbackFired = true})
        factory.answerCallbacks[multipleAnswerQuestion]?(["A1"])
        
        XCTAssertFalse(callbackFired)
    }
    
    func test_routeToQuetion_singleAnswer_configuresViewControllerWithoutSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in})
                
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuetion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in})
                
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuetion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswerSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in})
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleAnswerQuestion]?(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleAnswerQuestion]?([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuetion_multipleAnswerSubmitButton_progressToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        var callbackFired = false
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in callbackFired = true})
                
        factory.answerCallbacks[multipleAnswerQuestion]?(["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        
        XCTAssertTrue(callbackFired)
    }
    
    // MARK: Helpers

    // As in production we can have animated controller, to avoid delay due to animation, use animated false here
    // Don't change the behaviour
    class NonAnimatedNavigationCntroller: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestion = [Question<String>: UIViewController]()
        var answerCallbacks = [Question<String>: (([String]) -> Void)]()
        var stubbedResults = [Result<Question<String>, [String]>: UIViewController]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestion[question] = viewController
        }
        
        func stub(result: Result<Question<String>, [String]>, viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestion[question] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
