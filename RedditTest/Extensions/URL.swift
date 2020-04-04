//
//  URL.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/4/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation
import MobileCoreServices

public extension URL {
    
    var isImage: Bool {
        let ext = pathExtension
        let imageExtensions = ["png", "jpeg", "jpg"]
        return imageExtensions.contains(ext)
//        if ext.count > 0 {
//            let utis = UTTypeCreateAllIdentifiersForTag(kUTTagClassFilenameExtension,
//                                                        ext as CFString,
//                                                        nil)?.takeRetainedValue() as? [String]
//            if let utis = utis {
//                for uti in utis {
//                    let isImage = UTTypeConformsTo(uti as CFString, kUTTypeImage)
//                    print(isImage)
//                }
//            }
//        }
    }
}
