//
//  Router.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 14/11/21.
//

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question,
                 answerCallback: @escaping AnswerCallback)
    func routeTo(result: Result<Question, Answer>)
}
