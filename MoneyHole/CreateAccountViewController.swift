//
//  CreateAccountViewController.swift
//  MoneyHole
//
//  Created by Michael Leech on 6/30/15.
//  Copyright (c) 2015 MoneyHole. All rights reserved.
//

import Foundation

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.secureTextEntry = true
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser[ML_USER_AMOUNT_GIVEN_KEY] = 0.0
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                self.performSegueWithIdentifier("go", sender: self)
            } else {
                println("Error: \(error?.localizedDescription)")
                self.errorLabel.text = "Duplicate username!"
            }
            
        }
    }
}