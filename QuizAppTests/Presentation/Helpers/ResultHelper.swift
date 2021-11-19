//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

@testable import QuizGame

extension Result: Hashable {
    static func make(answers: [Question : Answer] = [:], scores: Int = 0) -> Result<Question, Answer> {
        return Result(answers: answers, scores: scores)
    }
    
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.scores == rhs.scores
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(scores)
    }
}
