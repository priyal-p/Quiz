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
        XCTAssertEqual(makeSUT(answers: [makeAnswer()]).tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let answer = makeAnswer(question: "Correct Q1", answer: "A1", isCorrectAnswer: true)
        let sut = makeSUT(answers: [answer])
        
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.answerLabel.text, "A1")
        XCTAssertEqual(cell?.questionLabel.text, "Correct Q1")
    }
    
    func test_viewDidLoad_withWrongAnswer_rendersWrongAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer()])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        XCTAssertNotNil(cell)
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let answer = makeAnswer(question: "Correct Q1", answer: "A1", isCorrectAnswer: false)
        let sut = makeSUT(answers: [answer])
        
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
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
                    isCorrectAnswer: Bool = false) -> PresentableAnswer {
        return PresentableAnswer(question: question,
                                 answer: answer,
                                 isCorrectAnswer: isCorrectAnswer)
    }
    
    func makeDummyAnswer() -> String {
        "An Answer"
    }
}
