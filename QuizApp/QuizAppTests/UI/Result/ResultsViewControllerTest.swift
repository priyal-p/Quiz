//
//  ResultsViewControllerTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 14/11/21.
//

import XCTest
@testable import QuizApp

class ResultsViewControllerTest: XCTestCase {
    func test_viewDidLoad_renderSummary() {
        XCTAssertEqual(makeSUT(summary: "Results").headerLabel.text, "Results")
    }
    
    func test_viewDidLoad_rendersAnswers() {
        XCTAssertEqual(makeSUT().tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer(), makeAnswer()]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let answer = makeAnswer(question: "Correct Q1", answer: "A1")
        let sut = makeSUT(answers: [answer])
        
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.answerLabel.text, "A1")
        XCTAssertEqual(cell?.questionLabel.text, "Correct Q1")
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let answer = makeAnswer(question: "Correct Q1", answer: "A1", wrongAnswer: "wrong")
        let sut = makeSUT(answers: [answer])
        
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "wrong")
        XCTAssertEqual(cell?.questionLabel.text, "Correct Q1")
    }
    
    //MARK: Helpers
    
    func makeSUT(summary: String = "",
                 answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        return sut
    }
    
    func makeAnswer(question: String = "",
                    answer: String = "",
                    wrongAnswer: String? = nil) -> PresentableAnswer {
        return PresentableAnswer(question: question,
                                 answer: answer,
                                 wrongAnswer: wrongAnswer)
    }
}
