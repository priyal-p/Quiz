//
//  Game.swift
//  QuizGame
//
//  Created by Priyal PORWAL on 14/11/21.
//

public class Game <Question,
                   Answer,
                   R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Flow<R>
    init(flow: Flow<R>) {
        self.flow = flow
    }
}

public func startGame<Question: Hashable, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> {
    let flow = Flow(questions: questions, router: router) {
        return scoring($0, correctAnswer: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer],
                                        correctAnswer: [Question: Answer]) -> Int {
    answers.reduce(0) { score, tuple in
        score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}
