//
//  PostsViewController.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

let commentIcon = "\u{1F4AC}"

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView?
    
    var viewModel = TopPostsViewModel()
    var isFirstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureTableView()
        viewModel.firstLoad()
    }
    
    func configureViewModel() {
        viewModel.reloadDataClosure = { [weak self] in
            self?.tableView?.reloadData()
            self?.tableView?.refreshControl?.endRefreshing()
        }
        viewModel.errorLoadDataClosure = { [weak self] _ in
            self?.tableView?.refreshControl?.endRefreshing()
        }
        viewModel.scrollTableClosure = { [weak self] indexPath in
            self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isFirstLoad {
            self.tableView?.layoutIfNeeded()
            self.scrollTableAfterLoadIfNeeded()
            self.isFirstLoad = false
        }
    }
    
    func scrollTableAfterLoadIfNeeded() {
        if let i = viewModel.calculateScrollIndexPath() {
            tableView?.scrollToRow(at: i, at: .top, animated: false)
        }
    }
    
    func configureTableView() {
        tableView?.registerCells(PostCell.self)
        tableView?.rowHeight = UITableView.automaticDimension
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView?.refreshControl = refreshControl
    }

    @objc func refresh() {
        viewModel.load()
    }
    
    
    func imageTappedOnCell(_ cell:PostCell) {
        if let indexPath = tableView?.indexPath(for: cell)  {
            viewModel.imageTappedAt(indexPath)
        }
    }
    
    func saveFirstVisibleIndexPath() {
        let indexPath = tableView?.indexPathsForVisibleRows?.first
        viewModel.saveFirstVisiblePostAt(indexPath)
    }

}

extension PostsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PostCell.self, indexPath: indexPath)
        let model = viewModel.postModelAt(indexPath)
        let view = cell.postContentView
        view?.authorLabel?.text = model?.author
        let countComments = model?.num_comments?.toString()
        view?.commentsLabel?.text = commentIcon + " ".appending(countComments)
        view?.titleLabel?.text = model?.title
        if let timestampCreated = model?.created_utc {
            let createdDate = Date(timeIntervalSince1970: timestampCreated)
            view?.postedTimeLabel?.text = createdDate.getElapsedInterval()
        }
        loadImage(fromURL:model?.thumbnail, completion: { image in
            let cell = tableView.cellForRow(at: indexPath) as? PostCell
            cell?.postContentView?.previewImageView?.image = image
        })
        cell.imageTapped = { [weak self] c in
            self?.imageTappedOnCell(c)
        }
        return cell
    }
    
}

extension PostsViewController:UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;
        if scrollOffset + scrollViewHeight > scrollContentSizeHeight * 0.95 {
            viewModel.loadBottom()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        saveFirstVisibleIndexPath()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            saveFirstVisibleIndexPath()
        }
    }

}
