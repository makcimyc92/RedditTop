//
//  TopPostsViewModel.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/4/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

struct PostsLocalModel:Loadable {
    @UserDefaultsPropertyWrapper(key: "firstVisiblePostId", defaultValue:nil)
    static var firstVisiblePostId: String?
    var after:String?
    var posts:[Children]?
}

class TopPostsViewModel {
    
//    var model:TopPostsModel?
    var reloadDataClosure:EmptyClosure?
    var scrollTableClosure:ClosureAcceptType<IndexPath>?
    var errorLoadDataClosure:ClosureAcceptType<Error?>?

    var postsModel = PostsLocalModel.loadModel()
    
    var count:Int {
        return postsModel?.posts?.count ?? 0
    }
    
    func addPosts(_ new:TopPostsModel?) {
        guard postsModel != nil else {
            replacePosts(new)
            return
        }
        if let childrens = new?.data?.children {
            postsModel?.after = new?.data?.after
            postsModel?.posts?.append(contentsOf: childrens)
            postsModel?.save()
            DispatchQueue.main.async {
                self.reloadDataClosure?()
            }
        }
    }
    
    func saveFirstVisiblePostAt(_ indexPath:IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        let post = postModelAt(indexPath)
        PostsLocalModel.firstVisiblePostId = post?.id
    }
    
    func replacePosts(_ new:TopPostsModel?) {
        if let new = new {
            postsModel = PostsLocalModel(after: new.data?.after, posts: new.data?.children)
            postsModel?.save()
            DispatchQueue.main.async {
                self.reloadDataClosure?()
            }
        }
    }
    
    func errorLoad(_ error:Error?) {
        DispatchQueue.main.async {
            self.errorLoadDataClosure?(error)
        }
    }
    
    func firstLoad() {
        if postsModel == nil {
            load()
        }
    }
    
    func calculateScrollIndexPath() -> IndexPath? {
        let id = PostsLocalModel.firstVisiblePostId
        let obj = postsModel?.posts?.enumerated().first(where: { (i) -> Bool in
            return i.element.data?.id == id
        })
        if let obj = obj {
            let indexPath = IndexPath(row: obj.offset, section: 0)
            return indexPath;
        }
        return nil
    }
    
    func load() {
        isBottomLoading = true
        requestTopPosts(nil) { [weak self] (result) in
            switch result {
            case .success(let model):
                self?.replacePosts(model)
            case .error(let error):
                self?.errorLoad(error)
            }
            self?.isBottomLoading = false
        }
    }
    
    var isBottomLoading = false
    
    func loadBottom() {
        if isBottomLoading {
            return
        }
        isBottomLoading = true
        requestTopPosts(postsModel?.after) { [weak self] (result) in
            switch result {
            case .success(let model):
                self?.addPosts(model)
            case .error(let error):
                self?.errorLoad(error)
            }
            self?.isBottomLoading = false
        }
    }
    
    func postModelAt(_ indexPath:IndexPath) -> PostModel? {
        return postsModel?.posts?[safe:indexPath.row]?.data
    }
    
    func imageTappedAt(_ indexPath:IndexPath) {
        let model = postModelAt(indexPath)
        if let url = model?.url?.asURL(),
            url.isImage {
            let vc = PreviewImageViewController()
            vc.imageURL = url
            App.shared.pushOnRootNavigation(vc, animated: true)
        }
    }
    
}
