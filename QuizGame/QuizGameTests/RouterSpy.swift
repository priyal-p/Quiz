//
//  RouterSpy.swift
//  QuizGameTests
//
//  Created by Priyal PORWAL on 14/11/21.
//

import QuizGame

class RouterSpy: Router {
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
