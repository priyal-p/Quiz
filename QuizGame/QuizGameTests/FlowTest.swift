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
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
    }
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(question: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_delegatesCorrectQuestionHandling() {
        makeSUT(question: ["Q1"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(question: ["Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(question: ["Q1", "Q2"]).start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(question: ["Q1", "Q2"])

        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerQuestion_WithTwoQuestions_delegatesSecondQuestionHandling() {
        let sut = makeSUT(question: ["Q1", "Q2"])

        sut.start()
        delegate.answerCallback("A1")
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_WithThreeQuestions_delegatesThirdQuestionHandling() {
        let sut = makeSUT(question: ["Q1", "Q2", "Q3"])

        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_WithOneQuestion_doesNotDelegateNextQuestionHandling() {
        let sut = makeSUT(question: ["Q1"])

        sut.start()
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_doesNotDelegateResultHandling() {
        makeSUT(question: []).start()
        
        XCTAssertEqual(delegate.handledResult?.answers, [:])
    }
    
    func test_startWithOneQuestion_doesNotDelegateResultHandling() {
        let sut = makeSUT(question: ["Q1"])
        sut.start()
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotDelegateResultHandling() {
        let sut = makeSUT(question: ["Q1", "Q2"])
        sut.start()
        delegate.answerCallback("A1")
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_delegateResultHandling() {
        let sut = makeSUT(question: ["Q1", "Q2"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult?.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(question: ["Q1", "Q2"]) { _ in
            return 10
        }
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult?.scores, 10)
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
        
        XCTAssertEqual(delegate.handledResult?.scores, 20)
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers
    
    private func makeSUT(question: [String],
                 scoring: @escaping ([String: String]) -> Int = { _ in return 0}) -> Flow<DelegateSpy> {
        let sut = Flow(questions: question, delegate: delegate, scoring: scoring)
        weakSUT = sut
        return sut
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var handledQuestions: [String] = []
        var answerCallback: (String) -> Void = {_ in }
        var handledResult: Result<String, String>? = nil
        
        func handle(question: String, answerCallback: @escaping AnswerCallback) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }

}
