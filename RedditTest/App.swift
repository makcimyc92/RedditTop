//
//  App.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

class App {
    static let shared = App()
    
    var rootNavigation:RootNavigationController?
    
    func pushOnRootNavigation(_ vc:UIViewController, animated:Bool) {
        rootNavigation?.pushViewController(vc, animated: true)
    }
}
