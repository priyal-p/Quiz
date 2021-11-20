//
//  Question.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 16/11/21.
//

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
