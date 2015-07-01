//
//  DollarImageView.swift
//  MoneyHole
//
//  Created by Michael Leech on 7/1/15.
//  Copyright (c) 2015 MoneyHole. All rights reserved.
//

import Foundation
import UIKit

class MLDollarImageView: UIImageView {
    
    var frameRate: NSTimeInterval = 0.1
    var numberOfFrames = 4
    var currentFrame = 0
    
    var timer: NSTimer!
    
    init() {
        super.init(image: UIImage(named: "dollar0"))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimating() {
        timer = NSTimer.scheduledTimerWithTimeInterval(frameRate, target: self, selector: "runAnimationLoop", userInfo: nil, repeats: true)
    }
    
    func runAnimationLoop() {
        image = UIImage(named: "dollar\(currentFrame)")
        
        if currentFrame == numberOfFrames - 1 {
            currentFrame = 0
        } else {
            currentFrame++
        }
    }
    
}