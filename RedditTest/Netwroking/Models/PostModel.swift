//
//  PostModel.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

struct PostModel:Codable {
    let id:String?
    let title: String?
    let name: String?
    let author: String?
    let thumbnail: String?
    let created_utc: Double?
    let num_comments: Int?
    let url:String?
}

struct TopPostsModel:Codable {
    let data: PostsModel?
}

struct PostsModel:Codable {
    let children: [Children]?
    let after:String?
}

struct Children:Codable {
    let data: PostModel?
}
