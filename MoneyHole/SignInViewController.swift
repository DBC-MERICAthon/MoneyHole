//
//  SignInViewController.swift
//  MoneyHole
//
//  Created by Michael Leech on 6/30/15.
//  Copyright (c) 2015 MoneyHole. All rights reserved.
//

import Foundation

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLabel.secureTextEntry = true
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameLabel.text, password: passwordLabel.text) { (user: PFUser?, error: NSError?) -> Void in
            
            if error == nil {
                self.performSegueWithIdentifier("go", sender: self)
            } else {
                println("Error: \(error?.localizedDescription)")
            }
        }
    }
}