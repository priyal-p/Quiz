//
//  Result.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 14/11/21.
//

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let scores: Int
}
