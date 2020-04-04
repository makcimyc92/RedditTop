//
//  PropertyWrapper.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/4/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultsPropertyWrapper<Value:Codable> {

    private let key: String
    private let defaultValue: Value?

    init(key:String, defaultValue:Value?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value? {
        get { (UserDefaults.standard.object(forKey: key) as? Value) ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key)}
    }

}
