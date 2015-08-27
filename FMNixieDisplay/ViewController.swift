//
//  ViewController.swift
//  FMNixieDisplay
//
//  Created by Simon Gladman on 27/08/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue = 2726055
    let nixieDigitDisplay = FMNixieDigitDisplay(numberOfDigits: 8)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        view.addSubview(nixieDigitDisplay)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerHandler", userInfo: nil, repeats: true)
    }

    func timerHandler()
    {
        currentValue = (currentValue + 1)
        
        nixieDigitDisplay.setValue(int: currentValue)
        
        // nixieDigitDisplay.setValue(float: Float(drand48()) * 10000)
    }
    
    override func viewDidLayoutSubviews()
    {
        nixieDigitDisplay.frame = CGRect(x: view.frame.width / 2 - nixieDigitDisplay.intrinsicContentSize().width / 2,
            y: view.frame.height / 2 - nixieDigitDisplay.intrinsicContentSize().height / 2,
            width: nixieDigitDisplay.intrinsicContentSize().width,
            height: nixieDigitDisplay.intrinsicContentSize().height)
    }

}

