//
//  QuestionTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 16/11/21.
//

import XCTest
@testable import QuizGame

class QuestionTest: XCTestCase {
    func test_hashValue_singleAnswer_returnsTypeHash() {
        let type = "A string"
        let sut = Question.singleAnswer(type)
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash() {
        let type = "A string"
        let sut = Question.multipleAnswer(type)
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_answer_isEqual() {
        XCTAssertEqual(Question.singleAnswer("A string"), Question.singleAnswer("A string"))
        XCTAssertEqual(Question.multipleAnswer("A string"), Question.multipleAnswer("A string"))
        
    }
    
    func test_answer_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer("A string"), Question.singleAnswer("A another string"))
        XCTAssertNotEqual(Question.multipleAnswer("A string"), Question.multipleAnswer("A another string"))
        XCTAssertNotEqual(Question.singleAnswer("A string"), Question.multipleAnswer("A string"))
    }
}
