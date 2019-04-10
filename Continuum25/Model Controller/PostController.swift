//
//  PostController.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    static let shared = PostController()
    var posts: [Post] = []

    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
    func createPostWith(photo: UIImage, caption: String, completion: @escaping(Post?) -> Void) {
        // Initialize a post from the image and new comment and append the post to the postController 's posts property (source of truth). The completion handler will be utilized with cloudkit integration
        let post = Post(photo: photo, caption: caption)
        self.posts.append(post)
        
    }
}
