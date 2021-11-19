//
//  UITableView+Extension.swift
//  QuizApp
//
//  Created by Priyal PORWAL on 14/11/21.
//

import UIKit

extension UITableView {
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T>(for type: T.Type) -> T? {
        let className = String(describing: type)
        return self.dequeueReusableCell(withIdentifier: className) as? T
    }
}
