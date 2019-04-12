//
//  UIViewControllerExtension.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/11/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentSimpleAlertWith(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(cancelButton)
        self.present(alertController, animated: true)
        
    }
}
