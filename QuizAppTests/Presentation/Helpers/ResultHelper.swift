//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

@testable import QuizGame

extension Result {
    static func make(answers: [Question : Answer] = [:], scores: Int = 0) -> Result<Question, Answer> {
        return Result(answers: answers, scores: scores)
    }
}

extension Result: Hashable where Answer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers)
        hasher.combine(scores)
    }
}

extension Result: Equatable where Answer: Equatable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.scores == rhs.scores && lhs.answers == rhs.answers
    }
}
