//
//  RedditAPI.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

class RedditAPI {
    
    static let baseURL = "https://www.reddit.com/top.json"
    private let session = URLSession.shared

    
    func request(_ apiTask:APITaskProtocol) {
        let request = apiTask.request()
        session.dataTask(with: request) { (data, response, error) in
            apiTask.setup(responseData: data, response: response, error: error)
        }
    }
    
}

typealias ClosureAcceptType<T> = (T) -> ()

func requestTopPosts(_ after:String?, completion:@escaping ClosureAcceptType<TopPostsModel>) {
    let url = RedditAPI.baseURL
    let urlSession = URLSession.shared
    guard let apiURL = URL(string:url) else {
        return
    }
    var requestURL = apiURL
    
    if let parameterAfter = after {
        
        let urlString = url + "?after=\(parameterAfter)"
        
        if let newURL = URL(string: urlString) {
            requestURL = newURL
        }
    }
    //      print(requestURL.absoluteString)
    
    var req = URLRequest(url: requestURL)
    
    req.addValue("application/json", forHTTPHeaderField: "Accept")
    req.addValue("UTF-8", forHTTPHeaderField: "charset")
    
    let task = urlSession.dataTask(with: req) { (data, response, error) in
        guard let aData = data else {
            return
        }
        do {
            let model = try JSONDecoder().decode(TopPostsModel.self, from: aData)
            completion(model)
        } catch {
            print(error)
        }
    }
    task.resume()
}

class TopPostsRequest {
    
}
