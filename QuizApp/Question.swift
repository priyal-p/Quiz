//
//  Question.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 16/11/21.
//

enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let value),
                .multipleAnswer(let value):
            hasher.combine(value)
        }
    }
    
    static func ==(lhs: Question<T>, rhs: Question<T>) -> Bool {
        switch (lhs, rhs) {
        case (.singleAnswer(let a), .singleAnswer(let b)) :
            return a == b
        case (.multipleAnswer(let a), .multipleAnswer(let b)) :
            return a == b
        default: return false
        }
    }
}
