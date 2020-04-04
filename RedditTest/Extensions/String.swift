//
//  String.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

extension String {
    func asURL() -> URL? {
        return URL(string: self)
    }
    
    func appending(_ str:String?) -> String {
        if let new = str {
            return appending(new)
        }
        return self
    }
}
