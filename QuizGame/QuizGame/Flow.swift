//
//  Flow.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 11/11/21.
//

class Flow <R: Router> {
    typealias Question = R.Question
    typealias Answer = R.Answer
    
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question],
         router: R,
         scoring: @escaping ([Question: Answer]) -> Int) {
        self.router = router
        self.questions = questions
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion,
                           answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> R.AnswerCallback {
        return { [weak self] answer in
            self?.routeNext(question, answer)
        }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, scores: scoring(answers))
    }
}
