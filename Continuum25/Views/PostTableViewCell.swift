//
//  PostTableViewCell.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post: Post? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        guard let post = post else {return}
        postImageView.image = post.photo
        captionLabel.text = post.caption
        commentCountLabel.text = "Comments: \(post.commentCount)"
        
    }
}
