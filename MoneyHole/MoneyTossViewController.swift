//
//  MoneyTossViewController.swift
//  MoneyHole
//
//  Created by Michael Leech on 6/30/15.
//  Copyright (c) 2015 MoneyHole. All rights reserved.
//

import Foundation

class MoneyTossViewController: UIViewController {
    
    let segmentedControlAmounts: [CGFloat] = [1, 5, 10, 20]
    
    var totalMoneyTossed: CGFloat = 0.0
    
    @IBOutlet weak var holeView: UIView!
    @IBOutlet weak var backgroundMask: UIImageView!
    @IBOutlet weak var moneyTossedLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let amountGiven = PFUser.currentUser()![ML_USER_AMOUNT_GIVEN_KEY] as? CGFloat
        totalMoneyTossed = amountGiven!
        moneyTossedLabel.text = "\(roundToPlaces(amountGiven!, places: 4))"
        
        // Load gesture recognizer
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedUp")
        gestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func swipedUp() {
        sendButton(self)
    }
    
    @IBAction func sendButton(sender: AnyObject) {

        // Locally update amount
        let amount = segmentedControlAmounts[segmentedControl.selectedSegmentIndex]
        
        totalMoneyTossed += amount
        moneyTossedLabel.text = "$\(roundToPlaces(totalMoneyTossed, places: 2))"
        
        for var i = 0; i < Int(amount); i++ {
            NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(i) * 0.2, target: self, selector: Selector("throwDollar"), userInfo: nil, repeats: false)
        }
        
        // Remotely update amount
        PFUser.currentUser()![ML_USER_AMOUNT_GIVEN_KEY] = totalMoneyTossed
        PFUser.currentUser()!.saveEventually(nil)
        
        // Create swipe activity for analytics
        let swipe = PFObject(className: ML_SWIPE_CLASS_NAME)
        swipe[ML_SWIPE_AMOUNT_IN_DOLLARS_KEY] = amount
        swipe[ML_SWIPE_USER_KEY] = PFUser.currentUser()!
        swipe.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
            }
        }
        

    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WelcomeViewController") as! ViewController
        self.presentViewController(vc, animated: true, completion: nil)
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }
    
    func throwDollar() {
        
        let dollarImageView = MLDollarImageView()
        dollarImageView.frame = CGRectMake(0, 0, 50, 50)
        dollarImageView.center = CGPointMake(view.center.x, view.frame.size.height - 120)
        view.addSubview(dollarImageView)
        
        dollarImageView.startAnimating()
        
        /*
        let dollarView = UIView(frame: CGRectMake(0, 0, 40, 20))
        dollarView.backgroundColor = UIColor.greenColor()
        dollarView.center = CGPointMake(view.center.x, view.frame.size.height - 120)
        view.addSubview(dollarView)
        */
        
        
        
        var xOffset: CGFloat!
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            let rand = arc4random_uniform(200)
            
            
            xOffset = CGFloat(Int(rand) - 100)
            dollarImageView.frame.origin.x -= xOffset
            }) { (success: Bool) -> Void in
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    dollarImageView.frame.origin.x += (2 * xOffset)
                    }, completion: { (success: Bool) -> Void in
                    
                        
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            dollarImageView.frame.origin.x -= xOffset
                        }, completion: nil)
                        
                })
                
                
        }
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            dollarImageView.center.y = 50.0
        }) { (success: Bool) -> Void in
            
            self.view.insertSubview(dollarImageView, belowSubview: self.backgroundMask)
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                dollarImageView.center.y = self.holeView.center.y
                }) { (success: Bool) -> Void in
                
                    dollarImageView.removeFromSuperview()
            }
        }
    }
    
    func roundToPlaces(value: CGFloat, places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return round(value * divisor) / divisor
    }
    
}