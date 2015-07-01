//
//  LeaderboardViewController.swift
//  MoneyHole
//
//  Created by Michael Leech on 6/30/15.
//  Copyright (c) 2015 MoneyHole. All rights reserved.
//

import Foundation

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let CellIdentifier = "LeaderboardTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Data
    var users = [PFUser]()
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadObjects()
    }
    
    func loadObjects() {
        let userQuery = PFUser.query()
        userQuery?.orderByDescending(ML_USER_AMOUNT_GIVEN_KEY)
        userQuery?.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users = objects as! [PFUser]
                self.tableView.reloadData()
            } else {
                println("Error: \(error?.localizedDescription)")
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! LeaderboardTableViewCell
        
        let user = users[indexPath.row]
        cell.placeNumberLabel.text = "\(indexPath.row + 1)"
        cell.usernameLabel.text = user.username
        
        let moneyDonated = user[ML_USER_AMOUNT_GIVEN_KEY] as? CGFloat
        cell.moneyDonatedLabel.text = "\(roundToPlaces(moneyDonated!, places: 3))"
        
        return cell
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func roundToPlaces(value: CGFloat, places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return round(value * divisor) / divisor
    }
}

