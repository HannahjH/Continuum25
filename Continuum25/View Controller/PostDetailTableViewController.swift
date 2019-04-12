//
//  PostDetailTableViewController.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var post: Post? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post else { return }
        DispatchQueue.main.async {
            PostController.shared.fetchComments(post: post) { (comments) in
                self.tableView.reloadData()
                
            }
        }
    }
    
    func updateViews() {
        guard let post = post else { return }
        photoImageView.image = post.photo
        tableView.reloadData()
    }
    
    func presentCommentAlertController() {
        let alertController = UIAlertController(title: "Add a Comment", message: "What say ye?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your comment here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let commentAction = UIAlertAction(title: "Comment", style: .default) { (_) in
            guard let commentText = alertController.textFields?.first?.text,
                !commentText.isEmpty,
                let post = self.post else { return }
            PostController.shared.addComment(text: commentText, post: post, completion: { (comment) in
            })
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(commentAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func commentButton(_ sender: Any) {
        presentCommentAlertController()
    }
    @IBAction func shareButton(_ sender: Any) {
        guard let caption = post?.caption, let photo = post?.photo else {return}
        let userActivity = UIActivityViewController(activityItems: [caption, photo], applicationActivities: nil)
        present(userActivity, animated: true)
        
    }
    @IBAction func followButton(_ sender: Any) {
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let comment = post?.comments[indexPath.row]
        cell.textLabel?.text = comment?.text
        //        cell.detailTextLabel?.text = comment?.timestamp
        return cell
    }
}
