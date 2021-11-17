//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

import XCTest
import QuizGame
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {
    let options = ["A1", "A2"]
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionViewController().options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionViewController().allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        XCTAssertTrue(makeQuestionViewController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }
    
    func test_resultViewController_createsViewController() {
        let result = Result(answers: [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]], scores: 1)
        let viewController = makeSUT(correctAnswers: [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]).resultViewController(for: result)
        XCTAssertNotNil(viewController as? ResultsViewController)
    }
    
    func test_resultViewController_createsViewControllerWithSummary() {
        let results = makeResults()
        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func test_resultViewController_createsViewControllerWithPresentableAnswers() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
    
    // MARK: Helpers
    
    func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionViewController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question : options]).questionViewController(for: question, answerCallback: {_ in }) as! QuestionViewController
    }
    
    func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        
        let result = Result(answers: userAnswers, scores: 2)
        
        let sut = makeSUT(correctAnswers: correctAnswers)
        
        let viewController = sut.resultViewController(for: result) as! ResultsViewController
        
        let presenter = ResultsPresenter(result: result, correctAnswers: correctAnswers, orderedQuestions: orderedQuestions)
        
        return (controller: viewController, presenter: presenter)
    }
}
