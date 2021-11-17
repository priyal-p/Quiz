//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {
    func test_questionViewController_createsControllerWithQuestion() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        let viewController = sut.questionViewController(for: question, answerCallack: {_ in }) as? QuestionViewController
        XCTAssertEqual(viewController?.question, "Q1")
    }
    
    func test_questionViewController_createsControllerWithOptions() {
        let options = ["A1", "A2"]
        let question = Question.singleAnswer("Q1")
        let sut = iOSViewControllerFactory(options: [question: options])
        let viewController = sut.questionViewController(for: question, answerCallack: {_ in }) as? QuestionViewController
        XCTAssertEqual(viewController?.options, options)
    }
}
