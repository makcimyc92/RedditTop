//
//  Loadable.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/4/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

protocol Loadable:Codable {
    
}

extension Loadable {
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            let key = String(describing: Self.self)
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func loadModel() -> Self? {
        let k = String(describing: self)
        if let storedData = UserDefaults.standard.data(forKey: k) {
            let model = try? JSONDecoder().decode(Self.self, from: storedData)
            return model
        }
        return nil
    }
    
}
