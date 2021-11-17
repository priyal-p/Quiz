//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 17/11/21.
//

import QuizGame

struct ResultsPresenter {
    let result: Result<Question<String>, [String]>
    
    var summary: String {
        return "You get \(result.scores)/\(result.answers.count) correct"
    }
}
