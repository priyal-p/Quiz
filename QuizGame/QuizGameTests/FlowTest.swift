//
//  FlowTest.swift
//  QuizGameTests
//
//  Created by Priyal PORWAL on 11/11/21.
//

import XCTest
@testable import QuizGame

class FlowTest: XCTestCase {
    
    private let delegate = DelegateSpy()
    
    private weak var weakSUT: Flow<DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT (Flow<DelegateSpy>) instance is not nil.")
    }
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(question: []).start()
        
        XCTAssertTrue(delegate.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_routeToQuestion() {
        makeSUT(question: ["Q1"]).start()

        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_routeToQuestion2() {
        makeSUT(question: ["Q2"]).start()

        XCTAssertEqual(delegate.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        makeSUT(question: ["Q1", "Q2"]).start()

        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(question: ["Q1", "Q2"])

        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerQuestion_WithTwoQuestions_routesToSecondQuestion() {
        let sut = makeSUT(question: ["Q1", "Q2"])

        sut.start()
        delegate.answerCallback("A1")
        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_WithThreeQuestions_routesToThirdQuestion() {
        let sut = makeSUT(question: ["Q1", "Q2", "Q3"])

        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_WithOneQuestion_doesNotroutesToNextQuestion() {
        let sut = makeSUT(question: ["Q1"])

        sut.start()
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_doesNotResult() {
        makeSUT(question: []).start()
        
        XCTAssertEqual(delegate.routedResult?.answers, [:])
    }
    
    func test_startWithOneQuestion_doesNotRouteToResult() {
        let sut = makeSUT(question: ["Q1"])
        sut.start()
        
        XCTAssertNil(delegate.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(question: ["Q1", "Q2"])
        sut.start()
        delegate.answerCallback("A1")
        XCTAssertNil(delegate.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routeToResult() {
        let sut = makeSUT(question: ["Q1", "Q2"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedResult?.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(question: ["Q1", "Q2"]) { _ in
            return 10
        }
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedResult?.scores, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers = [String: String]()
        let sut = makeSUT(question: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 20
        }
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedResult?.scores, 20)
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers
    
    private func makeSUT(question: [String],
                 scoring: @escaping ([String: String]) -> Int = { _ in return 0}) -> Flow<DelegateSpy> {
        Flow(questions: question, router: delegate, scoring: scoring)
    }
    
    private class DelegateSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: (String) -> Void = {_ in }
        var routedResult: Result<String, String>? = nil
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<String, String>) {
            routedResult = result
        }
    }

}
