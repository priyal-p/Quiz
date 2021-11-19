//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 17/11/21.
//

import QuizGame

extension Result: Hashable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.scores == rhs.scores
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(scores)
    }
}
