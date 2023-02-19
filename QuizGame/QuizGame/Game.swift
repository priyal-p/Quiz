//
//  Game.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 14/11/21.
//

@available(*, deprecated)
public class Game <Question,
                   Answer,
                   R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Any
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame
<Question: Hashable, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
        let flow = Flow(
            questions: questions,
            delegate: QuizDelegateToRouterAdapter(router: router)) {
        return scoring($0, correctAnswer: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    private let router: R

    init(router: R) {
        self.router = router
    }

    func handle(result: Result<R.Question, R.Answer>) {
        router.routeTo(result: result)
    }

    func handle(question: R.Question,
                answerCallback: @escaping R.AnswerCallback) {
        router.routeTo(question: question, answerCallback: answerCallback)
    }
}

private func scoring
<Question: Hashable, Answer: Equatable>(
    _ answers: [Question: Answer],
    correctAnswer: [Question: Answer]) -> Int {
    answers.reduce(0) { score, tuple in
        score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}
