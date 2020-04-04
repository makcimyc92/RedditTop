//
//  ImageLoadService.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

typealias ImageLoadedClosure = ClosureAcceptType<UIImage>

func loadImage(fromURL url: URL?, completion:@escaping ImageLoadedClosure) {
    guard let imageURL = url, imageURL.isImage else {
        return
    }
    let cache =  URLCache.shared
    let request = URLRequest(url: imageURL)
    DispatchQueue.global(qos: .userInitiated).async {
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }).resume()
        }
    }
}

func loadImage(fromURL url: String?, completion:@escaping ImageLoadedClosure) {
    loadImage(fromURL: url?.asURL(), completion: completion)
}
