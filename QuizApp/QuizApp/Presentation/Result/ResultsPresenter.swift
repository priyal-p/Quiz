//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 17/11/21.
//

import QuizGame

struct ResultsPresenter {
    let result: Result<Question<String>, [String]>
    let correctAnswers: [Question<String>: [String]]
    let options: [Question<String>: [String]]
    let orderedQuestions: [Question<String>]
    
    var summary: String {
        return "You get \(result.scores)/\(result.answers.count) correct"
    }
    
    var title: String {
        return "Result"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return orderedQuestions.map { (question) in
            guard let correctAnswer = correctAnswers[question],
            let userAnswer = result.answers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }
            return presentableAnswer(question, userAnswer, correctAnswer)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ userAnswer: [String], _ correctAnswer: [String]) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value),
                .multipleAnswer(let value):
            return PresentableAnswer(question: value, answer: formattedAnswer(ordered(correctAnswer, for: question)), wrongAnswer: formattedWrongAnswer(ordered(userAnswer, for: question), ordered(correctAnswer, for: question)))
        }
    }
    
    private func ordered(_ answers: [String], for question: Question<String>) -> [String] {
        guard let options = options[question] else { return [] }
        return options.filter { answers.contains($0) }
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ userAnswer: [String], _ correctAnswer: [String]) -> String? {
        return correctAnswer == userAnswer ? nil : formattedAnswer(userAnswer)
    }
}
