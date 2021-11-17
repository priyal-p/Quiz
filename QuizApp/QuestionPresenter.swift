//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 17/11/21.
//

import QuizGame

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String? {
        guard let index = questions.firstIndex(of: question) else { return nil }
        return "Question #\(index + 1)"
    }
}
