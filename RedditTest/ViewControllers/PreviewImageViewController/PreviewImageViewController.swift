//
//  PreviewImageViewController.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

class PreviewImageViewController: UIViewController {
    
    var imageURL:URL?
    var image:UIImage?
    var imageSaveManager = ImageSaveManager()
    @IBOutlet weak var imageView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadImage(fromURL: imageURL) { [weak self] (image) in
            self?.setupImage(image)
        }
    }
    
    func setupImage(_ image:UIImage?) {
        self.image = image
        self.imageView?.image = image
    }
    
    func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func saveTapped() {
        ImageSaveManager.saveImage(image, completion: { [weak self] (_) in
            self?.showOKAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }) { [weak self] (error) in
            self?.showOKAlertWith(title: "Save error", message: error.localizedDescription)
        }
    }
}

