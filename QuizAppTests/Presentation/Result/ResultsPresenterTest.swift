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
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func test_title_returnFormattedTitle() {
        let answers = Dictionary<Question<String>, Set<String>>()
        let result = Result(answers: answers, scores: 1)
        
        let sut = ResultsPresenter(result: result, correctAnswers: [:], options: [:], orderedQuestions: [])
        
        XCTAssertEqual(sut.title, "Result")
        
    }
    
    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let answers: Dictionary<Question<String>, Set<String>> = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]
        let result = Result(answers: answers, scores: 1)
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let orderedOptions = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]

        let sut = ResultsPresenter(result: result, correctAnswers: [:], options: orderedOptions, orderedQuestions: orderedQuestions)
        
        XCTAssertEqual(sut.summary, "You get 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let answers = Dictionary<Question<String>, Set<String>>()
        let result = Result(answers: answers, scores: 0)
        
        let sut = ResultsPresenter(result: result, correctAnswers: [:], options: [:], orderedQuestions: [])
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let answers: Dictionary<Question<String>, Set<String>> = [singleAnswerQuestion: ["A1"]]
        let correctAnswers = [singleAnswerQuestion: Set(["A2"])]
        let result = Result(answers: answers, scores: 0)
        let orderedOptions = [singleAnswerQuestion: ["A1", "A2"]]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, options: orderedOptions, orderedQuestions: [singleAnswerQuestion])
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let answers: Dictionary<Question<String>, Set<String>> = [singleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers = [singleAnswerQuestion: Set(["A2", "A3"])]
        let result = Result(answers: answers, scores: 0)
        let orderedOptions = [singleAnswerQuestion: ["A1", "A2", "A3", "A4"]]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, options: orderedOptions, orderedQuestions: [singleAnswerQuestion])
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withRightSingleAnswer_mapsAnswer() {
        let answers: Dictionary<Question<String>, Set<String>> = [singleAnswerQuestion: ["A1"]]
        let correctAnswers = [singleAnswerQuestion: Set(["A1"])]
        let result = Result(answers: answers, scores: 1)
        let orderedOptions = [singleAnswerQuestion: ["A1"]]

        
        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, options: orderedOptions, orderedQuestions: [singleAnswerQuestion])
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }
    
    func test_presentableAnswers_withRightMultipleAnswer_mapsAnswer() {
        let answers: Dictionary<Question<String>, Set<String>> = [singleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers = [singleAnswerQuestion: Set(["A1", "A4"])]
        let result = Result(answers: answers, scores: 0)
        let orderedOptions = [singleAnswerQuestion: ["A1", "A4"]]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, options: orderedOptions, orderedQuestions: [singleAnswerQuestion])
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let answers: Dictionary<Question<String>, Set<String>> = [singleAnswerQuestion: ["A1", "A4"], multipleAnswerQuestion: ["A2", "A3"]]
        let correctAnswers = [singleAnswerQuestion: Set(["A1", "A4"]),
                            multipleAnswerQuestion: Set(["A2", "A3"])]
        let orderedQuestions = [multipleAnswerQuestion, singleAnswerQuestion]
        let result = Result(answers: answers,
                            scores: 0)
        let orderedOptions = [ multipleAnswerQuestion: ["A2", "A3"], singleAnswerQuestion: ["A1", "A4"]]
        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, options: orderedOptions, orderedQuestions: orderedQuestions)
        
        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.last?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.last?.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last?.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A2, A3")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }
}
