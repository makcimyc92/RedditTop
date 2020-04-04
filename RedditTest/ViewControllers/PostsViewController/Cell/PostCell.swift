//
//  PostCell.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

class PostContentView: UIView {
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var authorLabel:UILabel?
    @IBOutlet weak var commentsLabel:UILabel?
    @IBOutlet weak var postedTimeLabel:UILabel?
    @IBOutlet weak var previewImageView:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
    }

}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postContentView:PostContentView?
    var imageTapped:ClosureAcceptType<PostCell>?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postContentView?.previewImageView?.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImageTapped))
        postContentView?.previewImageView?.addGestureRecognizer(tap)
    }
    
    @objc func previewImageTapped() {
        imageTapped?(self)
    }
    
}
