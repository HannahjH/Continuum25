//
//  Post.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Post {
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var commentCount: Int
    var comments: [Comment]
    var recordID: CKRecord.ID
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    // read and write for our photo property
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage?, caption: String, timestamp: Date = Date(), comments: [Comment] = [], commentCount: Int = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.commentCount = commentCount
        self.recordID = recordID
        self.photo = photo
        
    }
    
   convenience init?(ckRecord: CKRecord) {
    
            guard let caption = ckRecord[PostConstants.captionKey] as? String,
                let timestamp = ckRecord[PostConstants.timestampKey] as? Date,
                let imageAsset = ckRecord[PostConstants.photoKey] as? CKAsset,
                let commentCount = ckRecord[PostConstants.commentCountKey] as? Int else{ return nil}
        
        do {
            guard let imageAsset = imageAsset.fileURL else { return nil}
            let photoData = try Data(contentsOf: imageAsset)
            guard let image = UIImage(data: photoData) else { return nil }
            self.init(photo: image, caption: caption, timestamp: timestamp, comments: [], commentCount: commentCount, recordID: ckRecord.recordID)
        } catch {
            print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
            return nil
        }
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.contains(searchTerm) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm){
                    return true
                }
            }
        }
        return false
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostConstants.typeKey, recordID: post.recordID)
        self.setValue(post.caption, forKey: PostConstants.captionKey)
        self.setValue(post.timestamp, forKey: PostConstants.timestampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.photoKey)

    }
}

struct PostConstants {
    static let typeKey = "Post"
    static let captionKey = "caption"
    static let timestampKey = "timestamp"
    static let commentKey = "comment"
    static let commentCountKey = "commentCount"
    static let photoKey = "photo"
}


