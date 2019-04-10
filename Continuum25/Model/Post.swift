//
//  Post.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var commentCount: Int
    var comments: [Comment]
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(photo: UIImage?, caption: String, timestamp: Date = Date(), comments: [Comment] = [], commentCount: Int = 0) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.commentCount = commentCount
        self.photo = photo
    }
}


