//
//  UITableView.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCells(_ classes: AnyClass...) {
        for cellClass in classes {
            let className = String(describing: cellClass)
            let nib = UINib(nibName: className, bundle: nil)
            self.register(nib, forCellReuseIdentifier: className)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ ofClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: ofClass)
        return self.dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
    
}
