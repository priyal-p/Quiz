//
//  Flow.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 11/11/21.
//

class Flow <Delegate: QuizDelegate> {
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question],
         router: Delegate,
         scoring: @escaping ([Question: Answer]) -> Int) {
        self.delegate = router
        self.questions = questions
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            delegate.handle(question: firstQuestion,
                           answerCallback: nextCallback(from: firstQuestion))
        } else {
            delegate.handle(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> Delegate.AnswerCallback {
        return { [weak self] answer in
            self?.delegateNextQuestionHandling(question, answer)
        }
    }
    
    private func delegateNextQuestionHandling(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                delegate.handle(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                delegate.handle(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, scores: scoring(answers))
    }
}
