//
//  ImageSaveManager.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/4/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

class ImageSaveManager:NSObject {
    
    typealias SaveCompleteClosure = ClosureAcceptType<UIImage>
    typealias SaveErrorClosure = ClosureAcceptType<Error>
    
    var completionClosure:SaveCompleteClosure?
    var errorClosure:SaveErrorClosure?
    
    static func saveImage(_ image:UIImage?, completion:SaveCompleteClosure? = nil, error:SaveErrorClosure? = nil) {
        let im = ImageSaveManager()
        im.saveImage(image, completion: completion, error: error)
    }
    
    func saveImage(_ image:UIImage?, completion:SaveCompleteClosure? = nil, error:SaveErrorClosure? = nil) {
        guard let image = image else {
            return
        }
        self.completionClosure = completion
        self.errorClosure = error
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorClosure?(error)
        } else {
            completionClosure?(image)
        }
    }
    
}
