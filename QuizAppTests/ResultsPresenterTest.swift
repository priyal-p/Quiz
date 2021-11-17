//
//  ResultsPresenterTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

import XCTest
import QuizGame
@testable import QuizApp

class ResultsPresenterTest: XCTestCase {
    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let answers = [Question.singleAnswer("Q1"): ["A1"], Question.multipleAnswer("Q2"): ["A2", "A3"]]
        let result = Result(answers: answers, scores: 1)
        let sut = ResultsPresenter(result: result)
        XCTAssertEqual(sut.summary, "You get 1/2 correct")
    }
    
    func test_summary_withTwoQuestionsAndScoreTwo_returnsSummary() {
        let answers = [Question.singleAnswer("Q1"): ["A1"], Question.multipleAnswer("Q2"): ["A2"], Question.multipleAnswer("Q3"): ["A3"]]
        let result = Result(answers: answers, scores: 2)
        let sut = ResultsPresenter(result: result)
        XCTAssertEqual(sut.summary, "You get 2/3 correct")
    }
}
