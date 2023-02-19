//
//  QuizDelegate.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 19/02/23.
//

public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    typealias AnswerCallback = (Answer) -> Void

    func handle(question: Question,
                answerCallback: @escaping AnswerCallback)
    func handle(result: Result<Question, Answer>)
}
