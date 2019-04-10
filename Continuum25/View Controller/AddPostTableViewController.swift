//
//  AddPostTableViewController.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionTextField: UITextField!
        
    var photo: UIImage?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = nil
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let photo = photo,
            let caption = captionTextField.text else { return }
        PostController.shared.createPostWith(photo: photo, caption: caption) { (post) in
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelector" {
            let photoSelector = segue.destination as? PhotoSelectorViewController
            photoSelector?.delegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.photo = image
    }

}
