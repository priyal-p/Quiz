//
//  TableViewHelpers.swift
//  QuizAppTests
//
//  Created by Priyal PORWAL on 14/11/21.
//
import UIKit

extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
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
