//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 12/11/21.
//

import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_renderHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT().tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_withOneOptions_rendersOneOptionText() {
        var sut = makeSUT(options: ["A1", "A2"])
        XCTAssertEqual(sut.tableView.title(at: 0), "A1")
        sut = makeSUT(options: ["A1", "A2"])
        XCTAssertEqual(sut.tableView.title(at: 1), "A2")
    }
    
    func test_tableView_hasDataSource() {
        XCTAssertNotNil(makeSUT().tableView.dataSource)
    }
    
//    func test_tableView_hasDelegate() {
//        XCTAssertNotNil(makeSUT().tableView.delegate)
//    }
    
    // MARK: Helpers
    
    func test_optionSelected_notifiesDelegate() {
        var receivedAnswer = ""
        let sut = makeSUT(options: ["A1"]) {
            receivedAnswer = $0
        }
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertEqual(receivedAnswer, "A1")
    }
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping ((String) -> Void) = {_ in }) -> QuestionViewController {
        let sut = QuestionViewController(
            question: question,
            options: options,
            selection: selection)
        _ = sut.view
        return sut
    }
    
}

private extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String? {
        if let configuration = cell(at: row)?.contentConfiguration as? OptionCellContentConfiguration {
            return configuration.text
        }
        return nil
    }
}
