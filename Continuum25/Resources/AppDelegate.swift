//
//  AppDelegate.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/9/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkAccountStatus { (success) in
            let fetchedUserStatment = success ? "Successfully retrieved a logged in user" : "Failed to retrieve a logged in user"
            print(fetchedUserStatment)
        }
        return true
    }
    
    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion(false)
                return
            } else {
                DispatchQueue.main.async {
                    let tabBarController = self.window?.rootViewController
                    let errorText = "Sign into iCloud in settings"
                    switch status {
                    case .available:
                        completion(true);
                    default:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: nil)
                        completion(false)
                    }
                }
            }
        }
    }
}

