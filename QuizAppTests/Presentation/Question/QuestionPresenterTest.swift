//
//  QuestionPresenterTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

import XCTest
import QuizGame
@testable import QuizApp

class QuestionPresenterTest: XCTestCase {
    let question1 = Question.singleAnswer("Q1")
    let question2 = Question.multipleAnswer("Q2")
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1], question: question1)
        
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        
        XCTAssertEqual(sut.title, "Question #2")
    }
    
    func test_title_forNonExistantQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [question1, question2], question: Question.singleAnswer("Q3"))
        
        XCTAssertNil(sut.title)
    }
    
    func test_title_forNoQuestions_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("Q3"))
        
        XCTAssertNil(sut.title)
    }
}
