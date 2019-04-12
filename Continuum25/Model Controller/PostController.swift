//
//  PostController.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PostController {
    static let shared = PostController()
    private init() {
        subscribeToNewPosts(completion: nil)
    }
    
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        let record = CKRecord(comment: comment)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(nil)
                return
            }
            guard let record = record else { return }
            let comment = Comment(ckRecord: record, post: post)
            self.incrementCommentCount(post: post, completion: nil)
            completion(comment)
            
        }
    }
    
    func createPostWith(photo: UIImage, caption: String, completion: @escaping(Post?) -> Void) {
        // Initialize a post from the image and new comment and append the post to the postController 's posts property (source of truth). The completion handler will be utilized with cloudkit integration
        // Turn post -> ckRecord
        let post = Post(photo: photo, caption: caption)
        self.posts.append(post)
        let record = CKRecord(post: post)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(nil)
                return
            }
            guard let record = record else { return }
            let post = Post(ckRecord: record)
            completion(post)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.typeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(nil)
                return
            }
            guard let records = records else { return }
            let fetchedPost = records.compactMap{Post(ckRecord: $0) }
            self.posts = fetchedPost
            completion(fetchedPost)
        }
    }
    
    func fetchComments(post: Post, completion: @escaping ([Comment]?) -> Void) {
        let postReference = post.recordID
        //
        let predicate = NSPredicate(format: "%K == %@", CommentConstants.postReferenceKey, postReference)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        // check on github
        let query = CKQuery(recordType: CommentConstants.recordType, predicate: compoundPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(nil)
                return
            }
            guard let records = records else { return }
            let fetchedComments = records.compactMap{Comment(ckRecord: $0, post: post)}
            post.comments = fetchedComments
            completion(fetchedComments)
        }
    }
    
    func incrementCommentCount(post: Post, completion: ((Bool) -> Void)?) {
        post.commentCount += 1
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        modifyOperation.savePolicy = .changedKeys
        modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion?(false)
                return
            } else {
                completion?(true)
            }
        }
        CKContainer.default().publicCloudDatabase.add(modifyOperation)
    }
    // Subsciption for all posts
    func subscribeToNewPosts(completion: ((Bool, Error?) -> Void)?)  {
        let predicate = NSPredicate(value: true)
        //check in github if correct
        let subscription = CKQuerySubscription(recordType: "Post", predicate: predicate, subscriptionID: "AllPosts", options: .firesOnRecordCreation)
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "New post added to Continuum"
        notification.shouldBadge = true
        notification.shouldSendContentAvailable = true
        subscription.notification = notification
        
        publicDB.save(subscription) { (subscription, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion?(false, error)
            } else {
                completion?(true, nil)
            }
        }
    }
    
    func addSubscriptionTo(commentsForPost post: Post, completion: ((Bool, Error?) -> Void)?) {
        let postRecordID = post.recordID
        let predicate = NSPredicate(format: "%K = %@", CommentConstants.postReferenceKey, postRecordID)
        
    }
}
