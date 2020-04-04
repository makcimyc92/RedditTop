//
//  RedditAPI.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

let baseURL = "https://www.reddit.com/top.json"

enum NetwrokError:Error {
    case invalidURL
    case emptyData
}

enum Result<T> {
    case success(_ value:T)
    case error(_ error:Error?)
}

func requestTopPosts(_ after:String?,
                     completion:@escaping ClosureAcceptType<Result<TopPostsModel>>) {
    let url = baseURL
    let urlSession = URLSession.shared
    guard let apiURL = URL(string:url) else {
        completion(.error(NetwrokError.invalidURL))
        return
    }
    var requestURL = apiURL
    if let parameterAfter = after {
        let urlString = url + "?after=\(parameterAfter)"
        if let newURL = URL(string: urlString) {
            requestURL = newURL
        }
    }
    
    var req = URLRequest(url: requestURL)
    
    req.addValue("application/json", forHTTPHeaderField: "Accept")
    req.addValue("UTF-8", forHTTPHeaderField: "charset")
    
    let task = urlSession.dataTask(with: req) { (data, response, error) in
        guard let aData = data else {
            completion(.error(NetwrokError.emptyData))
            return
        }
        do {
            let model = try JSONDecoder().decode(TopPostsModel.self, from: aData)
            completion(.success(model))
        } catch {
            completion(.error(error))
        }
    }
    task.resume()
}
