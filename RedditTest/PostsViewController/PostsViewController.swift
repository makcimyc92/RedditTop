//
//  PostsViewController.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestTopPosts(nil) { (model) in
            print(model)
        }
        // Do any additional setup after loading the view.
    }

}
