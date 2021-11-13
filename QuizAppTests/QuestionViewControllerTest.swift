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
    
    func test_tableView_hasDelegate() {
        XCTAssertNotNil(makeSUT().tableView.delegate)
    }
    
    func test_optionSelected_amongTwoOptions_notifiesDelegateWithLastSelection() {
        // Given
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        
        // When
        sut.tableView.select(row: 0)
        
        // Expected
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        // When
        sut.tableView.select(row: 1)
        
        // Expected
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionDeselected_amongTwoOptions_doesNotNotifyDelegateWithEmptySelection() {
        // Given
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"]) { _ in callbackCount += 1 }
        
        // When
        sut.tableView.select(row: 0)
        
        // Expected
        XCTAssertEqual(callbackCount, 1)
        
        // When
        sut.tableView.deSelectRow(row: 0)
        
        // Expected
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_multipleSelectionEnabled_notifiesDelegateSelection() {
        // Given
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        // When
        sut.tableView.select(row: 0)
        
        // Expected
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        // When
        sut.tableView.select(row: 1)
        
        // Expected
        XCTAssertEqual(receivedAnswer, ["A1","A2"])
    }
    
    func test_optionDeselected_multipleSelectionEnabled_notifiesDelegate() {
        // Given
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        // When
        sut.tableView.select(row: 0)
        
        // Expected
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        // When
        sut.tableView.select(row: 1)
        
        // Expected
        XCTAssertEqual(receivedAnswer, ["A1","A2"])
        
        sut.tableView.deSelectRow(row: 0)
        XCTAssertEqual(receivedAnswer, ["A2"])
        sut.tableView.deSelectRow(row: 1)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping (([String]) -> Void) = {_ in }) -> QuestionViewController {
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
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        // To accumulate tableView selected rows and then call tableView delegate's didSelectRowAt
        selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deSelectRow(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        deselectRow(at: indexPath, animated: false)
        delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
}
